#!/usr/bin/env bash
set -euo pipefail

available_locales="$(LC_ALL=C locale -a 2>/dev/null || true)"
if printf '%s\n' "$available_locales" | grep -qi '^C\.UTF-8$'; then
  PIPELINE_UTF8_LOCALE="C.UTF-8"
elif printf '%s\n' "$available_locales" | grep -qi '^C\.utf8$'; then
  PIPELINE_UTF8_LOCALE="C.utf8"
elif printf '%s\n' "$available_locales" | grep -qi '^en_US\.UTF-8$'; then
  PIPELINE_UTF8_LOCALE="en_US.UTF-8"
else
  cat >&2 <<'EOF'
No UTF-8 locale found.

This translation pipeline needs a UTF-8 locale because the Lambdapi standard
library and mapping files contain Unicode identifiers. Please install or enable
one of: C.UTF-8, C.utf8, en_US.UTF-8.
EOF
  exit 2
fi
export LC_ALL="$PIPELINE_UTF8_LOCALE"
export LC_CTYPE="$PIPELINE_UTF8_LOCALE"
export LANG="$PIPELINE_UTF8_LOCALE"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROCQ_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$ROCQ_ROOT/.." && pwd)"

usage() {
  cat <<'EOF'
Usage: rocq/scripts/translate_stdlib_to_rocq.sh [SOURCE_DIR] [OUTPUT_DIR]

Translate the Rocq-compatible Lambdapi standard library to Rocq via Dedukti.

Defaults:
  SOURCE_DIR = repository root
  OUTPUT_DIR = rocq/build/rocq

Reduction.lp and files named *_rules.lp are intentionally ignored: they provide
optional Lambdapi rewrite-rule compatibility, not part of the Rocq export.
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

SRC="${1:-$REPO_ROOT}"
OUT="${2:-$ROCQ_ROOT/build/rocq}"

BUILD="$ROCQ_ROOT/build"
LP="$BUILD/lp"
DK="$BUILD/dk"
ROCQ="$OUT"
LOG="$BUILD/logs"

MODULES=(
  Prop Set FOL Eq Bool Classic Comp HOL Impred FunExt PropExt Epsilon
  Prod String Option Nat Pos Z List Conj Disj
)

if [ ! -d "$SRC" ]; then
  echo "Source stdlib directory does not exist: $SRC" >&2
  exit 2
fi

rm -rf "$BUILD"
mkdir -p "$LP" "$DK" "$ROCQ" "$LOG"

find "$SRC" -maxdepth 1 -name '*.lp' ! -name '*_rules.lp' ! -name 'Reduction.lp' -exec cp {} "$LP"/ \;
cp "$SRC/lambdapi.pkg" "$LP/lambdapi.pkg"
cp "$ROCQ_ROOT/encoding.lp" "$ROCQ/encoding.lp"
cp "$ROCQ_ROOT/mappings.lp" "$ROCQ/mappings.lp"
cp "$ROCQ_ROOT/mappings.v" "$ROCQ/mappings.v"
if [ -f "$ROCQ_ROOT/mappings-Z.lp" ]; then
  cp "$ROCQ_ROOT/mappings-Z.lp" "$ROCQ/mappings-Z.lp"
fi

perl -0pi -e 's/\bopaque([[:space:]]+symbol\b)/symbol/g' "$LP"/*.lp

cat > "$ROCQ/_CoqProject" <<'EOF'
mappings.v
Prop.v
Set.v
FOL.v
Eq.v
Bool.v
Classic.v
Comp.v
HOL.v
Impred.v
FunExt.v
PropExt.v
Epsilon.v
Prod.v
String.v
Option.v
Nat.v
Pos.v
Z.v
List.v
Conj.v
Disj.v
EOF

echo "Compiling Rocq mapping file"
(
  cd "$ROCQ"
  coqc mappings.v
) >"$LOG/mappings.coqc.out" 2>"$LOG/mappings.coqc.err" || {
  echo "Failed to compile mappings.v"
  echo "See $LOG/mappings.coqc.err"
  exit 1
}

for mod in "${MODULES[@]}"; do
  if [ ! -f "$LP/$mod.lp" ]; then
    continue
  fi

  echo "== $mod =="
  echo "  LP -> DK"
  (
    cd "$LP"
    lambdapi export -o dk "$mod.lp"
  ) >"$DK/$mod.dk" 2>"$LOG/$mod.dk.err" || {
    echo "Failed while exporting $mod.lp to DK"
    echo "See $LOG/$mod.dk.err"
    exit 1
  }

  module_mapping="$BUILD/mappings-$mod.lp"
  if [ -f "$ROCQ_ROOT/mappings-$mod.lp" ]; then
    python3 - "$ROCQ_ROOT/mappings.lp" "$ROCQ_ROOT/mappings-$mod.lp" "$module_mapping" <<'PY'
import re
import sys
from pathlib import Path

base = Path(sys.argv[1])
override = Path(sys.argv[2])
out = Path(sys.argv[3])

def mapped_sources(text):
    sources = set()
    for line in text.splitlines():
        m = re.search(r"≔\s*(.*?)\s*;", line)
        if m:
            sources.add(m.group(1))
    return sources

override_text = override.read_text(encoding="utf-8")
override_sources = mapped_sources(override_text)

kept = []
for line in base.read_text(encoding="utf-8").splitlines():
    m = re.search(r"≔\s*(.*?)\s*;", line)
    if m and m.group(1) in override_sources:
        continue
    kept.append(line)

out.write_text("\n".join(kept) + "\n\n" + override_text, encoding="utf-8")
PY
  else
    cp "$ROCQ_ROOT/mappings.lp" "$module_mapping"
  fi

  echo "  DK -> Rocq"
  ENCODING="$ROCQ_ROOT/encoding.lp" \
  MAPPING="$module_mapping" \
  MAPPINGS_MODULE="mappings" \
  "$SCRIPT_DIR/dk_to_rocq_minimal.sh" "$DK/$mod.dk" "$ROCQ/$mod.v" \
    >"$LOG/$mod.stt_coq.out" 2>"$LOG/$mod.stt_coq.err" || {
      echo "Failed while exporting $mod.dk to Rocq"
      echo "Generated DK: $DK/$mod.dk"
      echo "See $LOG/$mod.stt_coq.err"
      exit 1
    }

  echo "  coqc"
  (
    cd "$ROCQ"
    coqc "$mod.v"
  ) >"$LOG/$mod.coqc.out" 2>"$LOG/$mod.coqc.err" || {
    echo "First Rocq check failure: $mod.v"
    echo "Generated Rocq: $ROCQ/$mod.v"
    echo "See $LOG/$mod.coqc.err"
    exit 1
  }
done

echo "All configured stdlib modules translated and checked."
echo "Rocq output: $ROCQ"
