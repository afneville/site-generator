#!/bin/sh

mkdir -p out
mkdir -p src
rm -rf out/*
rm -rf src/*
mkdir -p out/res
cp -r ~/vcon/docs/* ./src/
cp -r src/res/* out/res/
cp -r res/*.js out/res/
find src -mindepth 1 \( -name '.git' -o -name 'out' -o -name 'res' -o -name 'dot' \) -prune -o -type d | cut -d/ -f2- | xargs -I {} mkdir -p out/{}
find out -mindepth 1 -maxdepth 1 -type d | xargs -I {} cp ./redirect.html {}/index.html

command="pandoc -f markdown -t html -s"
mathjax_flag="--mathjax=https://cdn.aneville.uk/mathjax/tex-svg.js"
constant_flags="--data-dir=$(pwd) --metadata-file=./metadata.yaml --lua-filter=md-to-html-links.lua --filter=pandoc-crossref --no-highlight"

buildblogpost="${command} ${constant_flags} ${mathjax_flag} --shift-heading-level-by=1 --template=templates/blog-post -o"
buildiframe="${command} ${constant_flags} --template=templates/contents-iframe -o"
buildindexsection="${command} ${constant_flags} --template=templates/index-section"
buildindex="${command} ${constant_flags} --template=templates/index-page --metadata title=index -o"

find src -mindepth 2 -type f -name '*.md' | grep -v '_contents' | cut -d'/' -f2- | cut -d'.' -f1 | xargs -I% $buildblogpost ./out/%.html ./src/%.md
find src -mindepth 2 -type f -name '_contents.md' | cut -d'/' -f2- | cut -d'.' -f1 | xargs -I% $buildiframe out/%.html src/%.md

echo "<div id=\"pages\">" >out/_index.html
find src -type f -name '_contents.md' | sort | xargs -n1 $buildindexsection >>out/_index.html
echo "</div>" >>out/_index.html
find out -mindepth 2 -type d -print | xargs -I {} cp ./redirect.html {}/index.html
$buildindex out/index.html out/_index.html
echo "" | pandoc -s -f html -t html --data-dir="./" --template=templates/error.html --metadata title=- -o out/error.html

sass res/:out/res
