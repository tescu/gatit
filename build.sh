#!/usr/bin/env bash
# Simple sitegen powered by Pandoc
shopt -s globstar
export updated="$(date '+%A, %d %B %Y')"
export retete=""
export recipes=""

# Clean
printf "%s\n" "Cleaning HTML files..."
[ -f "index.html" ] && rm -rv *.html ./c/*

printf "%s\n" "--> Building recipes..."
for page in www/*.md; do
	# Obține numele simplu
	barename="$(basename $page)"
	name="$(grep '^title:' $page | sed 's/title://')"
	# Schimbă extensia în .html
	out="c/${barename%.md}.html"
	printf "\t%s\n" "Building $barename..."
	pandoc -s --toc --template=res/tmp/reteta.html "$page" -o "$out"
	export retete="$retete<li><a href="./$out">$name</a></li>"
	# TODO: Include doar ultimele 10 rețete
	export recipes="$recipes<li><a href="./$out">$name</a></li>"
done

# Index
printf "%s\n" "--> Building index.html..."
envsubst < res/tmp/index.html > index.html
printf "%s\n" "--> Building categorii.html..."
envsubst < res/tmp/categorii.html > categorii.html

printf "\v%s\n" "Done!"
