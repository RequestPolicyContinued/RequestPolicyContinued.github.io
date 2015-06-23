#!/bin/bash
workdir="$(dirname $0)"
cd $workdir
mdfiles=$(find ./ -maxdepth 1 -name "*.md")
#pagenames=$(echo $mdfiles | sed 's/\.md//g' | sed 's|./||g')

for file in $mdfiles; do
	outfile="$(basename "$file" .md).html"
	sed -f replace.sed < "$file" | pandoc -f markdown_github \
    -t html5 -s \
    -c "$(dirname $0)/github-markdown.css" \
    -o "$outfile"
done

cp Home.html index.html