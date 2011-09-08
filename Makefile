LATEX := pdflatex -shell-escape
BIBTEX := bibtex
DOT := dot

PAPER := paper

DEPS := 

ifneq (,$(findstring Darwin,$(shell uname)))
OPEN  := open
else
OPEN  := gnome-open
endif

open: $(addsuffix .pdf.open,$(PAPER))

all: $(addsuffix .pdf,$(PAPER)) latex.zip

clean: $(addsuffix .clean,$(PAPER))

up:
	cvs up -dPR

TEXFILES := $(addsuffix .tex,$(PAPER)) $(addsuffix .bbl,$(PAPER))
latex.zip: $(TEXFILES)
	zip $@ $(TEXFILES)

%.clean:
	@rm -fv $*.aux $*.bbl $*.toc $*.blg $*.log $*.out $*.pdf *~

%.png: %.dot
	$(DOT) $< -Tpng >$@

%.svg: %.dot
	$(DOT) $< -Tsvg >$@

%.eps: %.dot
	$(DOT) $< -Teps >$@

%.pdf: %.tex $(DEPS)
	test -e $*.aux && rm $*.aux || eval
	$(LATEX) $*
	$(BIBTEX) $*
	$(LATEX) $*
	$(LATEX) $*

%.pdf.nobib: %.tex $(DEPS)
	test -e $*.aux && rm $*.aux || eval
	$(LATEX) $*
	$(LATEX) $*
	open $*.pdf

%.open: %
	$(OPEN) $<

.SECONDARY:
