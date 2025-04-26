#!/bin/bash

option="${1:-PDF}"     ## set default output
option="${option,,}"   ## to lower case

SRCr=$(ls -tr *.Rmd | tail -1)           ## most recent .Rmd
HTML=$(ls -tr ./_book/*.html | tail -1)  ## most recent .html
PDFr=$(ls -tr ./_book/*.pdf | tail -1)
PDF="$(find "./_book" -type f -iname "*.pdf" | grep -v ".*_D[0-9]\+Q[0-9]\+.*.pdf" | tail -1)"
PDFp="$(find "./_book" -type f -iname "*.pdf" | grep ".*_D[0-9]\+Q[0-9]\+BM.pdf" | tail -1)"

# echo $SRC
# echo $SRCr
# echo $option
# echo $HTML
# echo $PDFr
# echo $PDF
# echo $PDFp


function build_pdf() {
    echo ""
    echo "You want a new pdf"
    if [ "$PDF" -ot "$SRCr" ]; then
        echo "$PDF older than $SRCr will build new pdf"
        echo ""
        Rscript -e "rmarkdown::render_site(output_format = 'bookdown::pdf_book', encoding = 'UTF-8')"
    else
        echo "but $PDF newer than $SRCr don't have to build pdf"
        echo ""
    fi
}


function build_html() {
    echo ""
    echo "You want a new html"
    if [ "$HTML" -ot "$SRCr" ]; then
        echo "$HTML older than $SRCr will build new html site"
        echo ""
        Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
    else
        echo "but $HTML newer than $SRCr don't have to build new html site"
        echo ""
    fi
}

function public_pdf(){
    if [ "$PDFp" -ot "$PDF" ]; then
        echo "$PDFp older than $PDF will build new public pdf"
        ## make a new public pdf
        $HOME/BASH/TOOLS/pdf_raster_fast.sh \
            -d 250     \
            -q 80      \
            -p "$PDF"
    else
        echo "but $PDFp newer than $PDF don't have to build new public pdf"
        echo ""
    fi
}



####  PDF  ####
if [[ "$option" == "pdf" ]]; then

    ## make a new PDF if needed
    build_pdf

    ## open file with okular
    wait
    nohup okular --unique "$PDF"  &  > /dev/null

    exit 0
fi


####  Public PDF  ####
if [[ "$option" == "public" ]]; then
    echo ""
    echo "You want to export pdf for public"
    
    ## make a new pdf if needed
    build_pdf 
    
    ## conver to public raster 
    public_pdf

    exit 0
fi


####  html site  ####
if [[ "$option" == "html" ]]; then
    ## make new html site if neaded
    build_html
fi


if [[ "$option" == "all" ]]; then
    echo ""
    
    # ## use config from document
    # Rscript -e "rmarkdown::render_site(encoding = 'UTF-8')"

    ## build one by one
    
    build_pdf

    public_pdf

    build_html
    
    exit 0
fi

exit 1
