#!/bin/bash
# Build script for RequestPolicy Continued documentation
# https://github.com/RequestPolicyContinued
# License: CC-BY-SA 3.0
# Usage: ./build.sh

set -o errexit
set -o nounset

workdir="$(dirname $0)"
cd $workdir
mdfiles=$(find ./ -maxdepth 1 -name "*.md")

for file in $mdfiles; do
	outfile="$(basename "$file" .md).html"
	sed --regexp-extended --file replace.sed < "$file" | \
    pandoc --from markdown_github \
    --write html5 \
    --standalone \
    --css "$(dirname $0)/github-markdown.css" \
    --output "$outfile"
done

cp Home.html index.html
