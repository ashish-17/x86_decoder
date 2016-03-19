TESTS=$(shell find . -maxdepth 1 -name '*.test.v')
BINS=$(TESTS:.v=.run)

VFLAGS=-g 2009 -Wall


all: $(BINS)

%.run: %.v
	iverilog $(VFLAGS) $< -o $@

clean:
	rm -fv *.run *.vcd *.out Makefile.deps


.INTERMEDIATE: $(BINS:.run=.v.dep)
%.v.dep: %.v
	$(eval TMPF=$(shell mktemp))
	iverilog $(VFLAGS) -Minclude=$(TMPF) $< -o /dev/null
	sed -i -e "1i $@:" -e 's/\.v\.dep:/.run:/' $(TMPF)
	paste -sd ' ' $(TMPF) > $@
	paste -sd ' ' $(TMPF) | sed -e 's/\.v\.dep:/.run:/' >> $@
	rm -f $(TMPF)

Makefile.deps: $(BINS:.run=.v.dep)
	cat $^ /dev/null > $@

ifneq ($(BINS),)
include Makefile.deps
endif
