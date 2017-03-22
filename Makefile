SRCDIR := src
SRCFILES := $(wildcard $(SRCDIR)/*.scm)
TESTFILES := $(addsuffix .test, $(basename $(SRCFILES)))

export GUILE_LOAD_PATH = $(SRCDIR)

all : test

test : $(TESTFILES)

%.test : %.scm 
	@guile --no-auto-compile -s $<

.PHONY: all test %.test
