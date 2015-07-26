#!/bin/bash
# Build script for RequestPolicy Continued documentation
# https://github.com/RequestPolicyContinued
# License: CC-BY-SA 3.0
# Usage: ./build.sh

set -o errexit
set -o nounset


function gettitle() {
	grep '<!-- HTMLTITLE' "$1" | \
	sed -e 's/<!-- HTMLTITLE //g' -e 's/-->//g'
}

workdir="$(dirname $0)"
cd $workdir
mdfiles=$(find ./ -maxdepth 1 -name "*.md")

for file in $mdfiles; do
	htmltitle=$(gettitle "$file")
	outfile="$(basename "$file" .md).html"
	sed --file replace.sed < "$file" | \
    pandoc --from markdown_github \
    --title-prefix="$htmltitle" \
    --write html5 \
    --standalone \
    --css "$(dirname $0)/github-markdown.css" \
    --output "$outfile"
done

cp Home.html index.html