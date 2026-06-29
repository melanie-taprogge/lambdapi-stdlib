COQC ?= coqc

.PHONY: all support generated clean

all: generated

support: mappings.vo

mappings.vo: mappings.v
	$(COQC) mappings.v

generated:
	$(MAKE) -C partial_stdlib

clean:
	$(MAKE) -C partial_stdlib clean
	rm -f .*.aux *.glob *.vo *.vos *.vok rocq.mk rocq.mk.conf .rocq.mk.d
