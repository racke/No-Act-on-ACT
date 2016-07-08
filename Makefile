# Makefile, see http://cgibbons.berkeley.edu/Research/Papers/MakefileTutorial.pdf

PODFILE=
TEXFILE=no-act-on-act-beamer
SLIDE_INPUTS=no-act-on-act-en-beamer.tex
SLIDE_OUTPUTS=$(SLIDE_INPUTS:%.tex=%.pdf)
HANDOUT_INPUTS=no-act-on-act-en-handout.tex
HANDOUT_OUTPUTS=$(HANDOUT_INPUTS:%.tex=%.pdf)
NOTES_INPUTS=no-act-on-act-en-notes.tex
NOTES_OUTPUTS=$(NOTES_INPUTS:%.tex=%.pdf)

all: $(SLIDE_OUTPUTS) $(HANDOUT_OUTPUTS) clean

.PHONY: all clean

$(PODFILE).html: $(PODFILE).pod
	./pod2xhtml $(PODFILE).pod > $(PODFILE).html

$(SLIDE_OUTPUTS): %-beamer.pdf: %.tex $(SLIDE_INPUTS)
# initial run
	pdflatex $(<:%.tex=%-beamer.tex)

# run BibTeX if missing citations
	@if(grep "Citation" $(<:%.tex=%-beamer).log > /dev/null);\
    then \
        bibtext $(<:%.tex=%-beamer); \
		pdflatex $(<:%.tex=%-beamer); \
    fi

# rerun if necessary
	@if(grep "Rerun" $(<:%.tex=%-beamer).log > /dev/null);\
    then \
		pdflatex $(<:%.tex=%-beamer); \
    fi

$(HANDOUT_OUTPUTS): %-handout.pdf: %.tex $(HANDOUT_INPUTS)
# initial run
	pdflatex $(<:%.tex=%-handout.tex)

# run BibTeX if missing citations
	@if(grep "Citation" $(<:%.tex=%-handout).log > /dev/null);\
    then \
        bibtext $(<:%.tex=%-handout); \
		pdflatex $(<:%.tex=%-handout); \
    fi

# rerun if necessary
	@if(grep "Rerun" $(<:%.tex=%-handout).log > /dev/null);\
    then \
		pdflatex $(<:%.tex=%-handout); \
    fi

$(NOTES_OUTPUTS): %-notes.pdf: %.tex $(NOTES_INPUTS)
# initial run
	pdflatex $(<:%.tex=%-notes.tex)

# run BibTeX if missing citations
	@if(grep "Citation" $(<:%.tex=%-notes).log > /dev/null);\
    then \
        bibtext $(<:%.tex=%-notes); \
		pdflatex $(<:%.tex=%-notes); \
    fi

# rerun if necessary
	@if(grep "Rerun" $(<:%.tex=%-notes).log > /dev/null);\
    then \
		pdflatex $(<:%.tex=%-notes); \
    fi

# Remove unnecessary files
clean:
	-rm -f *.log *.aux *.out *.blg *.bbl *.nav *.snm *.toc

# cleanup the pdf as well
distclean: clean
	-rm -f *.pdf
