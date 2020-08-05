#!/bin/bash

yesterday="$(date -d yesterday '+%Y-%m-%d')"

git -C ../../covid-19 pull

Rscript covid-exit.R $yesterday
