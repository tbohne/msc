#!/bin/bash
pdflatex expose.tex
bibtex expose.aux
pdflatex expose.tex
pdflatex expose.tex
