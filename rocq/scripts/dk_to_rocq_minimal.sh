#!/usr/bin/env bash
set -euo pipefail

IN="${1:?Usage: dk_to_rocq_minimal.sh input.dk output.v}"
OUT="${2:?Usage: dk_to_rocq_minimal.sh input.dk output.v}"

ENCODING="${ENCODING:?Set ENCODING to an encoding.lp file}"
MAPPING="${MAPPING:?Set MAPPING to a mappings.lp file}"
MAPPINGS_MODULE="${MAPPINGS_MODULE:-mappings}"
DROP_IMPORTS_REGEX="${DROP_IMPORTS_REGEX:-Prop|Set}"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

tmpdk="$tmpdir/$(basename "$IN")"
tmpencoding="$tmpdir/encoding.lp"
tmpmapping="$tmpdir/mappings.lp"
restore_names="$tmpdir/restore-names.tsv"
all_imports="$tmpdir/all-imports.v"
imports="$tmpdir/imports.v"
body="$tmpdir/body.v"

grep '^#REQUIRE ' "$IN" 2>/dev/null | \
  sed -E \
    -e 's/^#REQUIRE[[:space:]]+\{\|([^|]+)\|\}\./Require Import \1./' \
    -e 's/^#REQUIRE[[:space:]]+([^.]+)\./Require Import \1./' \
  > "$all_imports" || true

grep -Ev "^Require Import (${DROP_IMPORTS_REGEX})\\.$" "$all_imports" \
  > "$imports" || true

python3 - "$IN" "$tmpdk" <<'PY'
import re
import sys
from pathlib import Path

src = Path(sys.argv[1])
dst = Path(sys.argv[2])

out = []
for line in src.read_text(encoding="utf-8").splitlines():
    stripped = line.lstrip()
    if stripped.startswith("#REQUIRE "):
        continue
    if re.match(r"^\[[^\]]*\]\s+.*-->", stripped):
        continue
    out.append(line)

dst.write_text("\n".join(out) + "\n", encoding="utf-8")
PY

python3 - "$tmpdk" "$all_imports" <<'PY'
import re
import sys
from pathlib import Path

dk_path = Path(sys.argv[1])
imports_path = Path(sys.argv[2])
text = dk_path.read_text(encoding="utf-8")

modules = []
for line in imports_path.read_text(encoding="utf-8").splitlines():
    m = re.match(r"Require Import\s+([A-Za-z0-9_']+)\.", line)
    if m:
        modules.append(m.group(1))

for mod in sorted(set(modules), key=len, reverse=True):
    text = re.sub(
        r"\{\|" + re.escape(mod) + r"\|\}\.(\{\|[^|]+\|\})",
        r"\1",
        text,
    )
    text = re.sub(
        r"\{\|" + re.escape(mod) + r"\|\}\.([A-Za-z_][A-Za-z0-9_']*)",
        r"\1",
        text,
    )
    text = re.sub(
        r"\b" + re.escape(mod) + r"\.([A-Za-z_][A-Za-z0-9_']*)",
        r"\1",
        text,
    )
    text = re.sub(
        r"\b" + re.escape(mod) + r"\.(\{\|[^|]+\|\})",
        r"\1",
        text,
    )

dk_path.write_text(text, encoding="utf-8")
PY

python3 - "$tmpdk" "$ENCODING" "$tmpencoding" "$MAPPING" "$tmpmapping" "$restore_names" <<'PY'
import re
import sys
import unicodedata
from pathlib import Path

dk_path = Path(sys.argv[1])
encoding_in = Path(sys.argv[2])
encoding_out = Path(sys.argv[3])
mapping_in = Path(sys.argv[4])
mapping_out = Path(sys.argv[5])
restore_path = Path(sys.argv[6])

known = {
    "#admit": "lp_hash_admit",
    "#apply": "lp_hash_apply",
    "#assume": "lp_hash_assume",
    "#fail": "lp_hash_fail",
    "#generalize": "lp_hash_generalize",
    "#have": "lp_hash_have",
    "#induction": "lp_hash_induction",
    "#orelse": "lp_hash_orelse",
    "#refine": "lp_hash_refine",
    "#reflexivity": "lp_hash_reflexivity",
    "#remove": "lp_hash_remove",
    "#repeat": "lp_hash_repeat",
    "#rewrite": "lp_hash_rewrite",
    "#set": "lp_hash_set",
    "#simplify": "lp_hash_simplify",
    "#simplify_beta": "lp_hash_simplify_beta",
    "#solve": "lp_hash_solve",
    "#symmetry": "lp_hash_symmetry",
    "#try": "lp_hash_try",
    "#why3": "lp_hash_why3",
}

def sanitize(name: str) -> str:
    if name in known:
        return known[name]
    out = []
    for ch in unicodedata.normalize("NFC", name):
        if ch.isascii() and (ch.isalnum() or ch == "_"):
            out.append(ch)
        elif ch == "'":
            out.append("_prime")
        else:
            out.append(f"_u{ord(ch):04x}_")
    ident = "".join(out)
    ident = re.sub(r"_+", "_", ident).strip("_")
    if not ident or not (ident[0].isalpha() or ident[0] == "_"):
        ident = "lp_" + ident
    elif not ident.startswith("lp_"):
        ident = "lp_" + ident
    return ident

def is_rocq_plain_ident(name: str) -> bool:
    if not name:
        return False
    if not (name[0] == "_" or unicodedata.category(name[0]).startswith("L")):
        return False
    for ch in name[1:]:
        cat = unicodedata.category(ch)
        if ch in "_'" or cat.startswith("L") or cat.startswith("N"):
            continue
        return False
    return True

restore = {}

def rewrite_quoted(text: str) -> str:
    def repl(m):
        original = m.group(1)
        ident = sanitize(original)
        if original != ident and is_rocq_plain_ident(original):
            restore[ident] = original
        return ident
    return re.sub(r"\{\|([^|]+)\|\}", repl, text)

dk_path.write_text(rewrite_quoted(dk_path.read_text(encoding="utf-8")), encoding="utf-8")
encoding_out.write_text(rewrite_quoted(encoding_in.read_text(encoding="utf-8")), encoding="utf-8")
mapping_out.write_text(rewrite_quoted(mapping_in.read_text(encoding="utf-8")), encoding="utf-8")
restore_path.write_text(
    "".join(f"{k}\t{v}\n" for k, v in sorted(restore.items(), key=lambda kv: len(kv[0]), reverse=True)),
    encoding="utf-8",
)
PY

lambdapi export -o stt_coq \
  --encoding "$tmpencoding" \
  --use-notations \
  --mapping "$tmpmapping" \
  "$tmpdk" > "$body"

python3 - "$body" "$restore_names" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
restore_path = Path(sys.argv[2])
text = path.read_text(encoding="utf-8")

text = re.sub(r"\{\|([^|]+)\|\}", r"\1", text)

if restore_path.exists():
    for line in restore_path.read_text(encoding="utf-8").splitlines():
        if not line:
            continue
        ascii_name, unicode_name = line.split("\t", 1)
        text = re.sub(
            r"(?<![A-Za-z0-9_'])" + re.escape(ascii_name) + r"(?![A-Za-z0-9_'])",
            unicode_name,
            text,
        )

text = text.replace("@conj ", "@Logic.conj ")
text = re.sub(
    r"(?<![A-Za-z0-9_'])([0-9][A-Za-z0-9_']*_[A-Za-z0-9_']*)(?![A-Za-z0-9_'])",
    r"lp_\1",
    text,
)

text = re.sub(r"\(eq ([A-Za-z_][A-Za-z0-9_']*)\)", r"(@eq \1)", text)
text = re.sub(r"\(eq (\([^()]+(?:\s*->\s*[^()]+)+\))\)", r"(@eq \1)", text)

path.write_text(text, encoding="utf-8")
PY

{
  cat "$imports"
  echo "Require Import $MAPPINGS_MODULE."
  cat "$body"
} > "$OUT"
