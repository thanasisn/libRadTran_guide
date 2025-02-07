## find all sources
SOURCES  = Makefile $(wildcard *.Rmd) $(wildcard *.yml) $(wildcard *.tex)

## target files
TARGET := _book/Natsis_Phd
PDF    := $(TARGET)_partial.pdf
DOC    := $(TARGET)_partial.docx
FULLP  := $(TARGET).pdf
FULLD  := $(TARGET).docx
## fullpath of makefile
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
## just the current folder
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

## make config=_bookdownALL.yml
config = ./_bookdown.yml

.DEFAULT_GOAL := all

all:  test

test: $(SOURCES)
	#- Rscript -e "rmarkdown::render_book('00_00_params.yml', 'bookdown::pdf_book', config_file = '_bookdown.yml')"
	echo $?



## draft pdf
pdf: $(PDF)
$(PDF): $(SOURCES)
	- Rscript -e "bookdown::render_book('00_00_params.yml', 'bookdown::pdf_book', config_file = '_bookdown.yml')"
	@ echo "Building: $@"
	@ echo "Changed:  $?"
	#@ cp -r -u -p "_book/." ${COPYTARGET}/$(current_dir)
	@ rm Natsis_Phd*.tdo





