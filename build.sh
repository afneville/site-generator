#!/bin/sh

mkdir -p src
mkdir -p out
mkdir -p out/res
rm -rf src/*
cp -r ~/vcon/docs/* ./src/
cp -r src/res/* ./out/res/

# copy directories
find src -mindepth 1 \( -name '.git' -o -name 'out' -o -name 'res' -o -name 'dot' \) -prune -o -type d | cut -d/ -f2- | xargs -I {} mkdir -p out/{}
find out -mindepth 1 -maxdepth 1 -type d | xargs -I {} cp ./redirect.html {}/index.html

# build commands

current_date="$(date '+%Y-%m-%d')"
current_time="$(date '+%H:%M:%S')"
current_commit="$(git -C ../docs rev-parse HEAD)"
current_commit_short="$(git -C ../docs rev-parse --short HEAD)"
command="pandoc -f markdown -t html -s"
mathjax_flag="--mathjax=https://cdn.afneville.com/mathjax/tex-svg.js"
constant_flags="--data-dir=$(pwd) --metadata-file=./metadata.yaml --lua-filter=md-to-html-links.lua --filter=pandoc-crossref --no-highlight"
buildblogpost="${command} ${constant_flags} ${mathjax_flag} --shift-heading-level-by=1 --template=templates/blog-post -o"
buildindexsection="${command} ${constant_flags} --template=templates/index-section"
buildindex="${command} ${constant_flags} --template=templates/index-page --metadata title=index --metadata date=${current_date} --metadata time=${current_time} --metadata commit=${current_commit} --metadata shortcommit=${current_commit_short} -o"

# articles
posts="$(find src -mindepth 2 -type f -name '*.md' | grep -v '_contents')"
for i in $posts; do
    echo "$(tail -n +5 "$(dirname ${i})/_contents.md")" > "$(dirname ${i})/__contents.md"
    $buildblogpost "$(echo "$i" | cut -d'/' -f2- | cut -d'.' -f1 | xargs -I% echo out/%.html )" "$i" templates/see-also.md "$(dirname ${i})/__contents.md" templates/back.md
done

# index and error pages
echo "<div id=\"pages\">" >out/_index.html
find src -type f -name '_contents.md' | sort | xargs -n1 $buildindexsection >>out/_index.html
echo "</div>" >>out/_index.html
find out -mindepth 2 -type d -print | xargs -I {} cp ./redirect.html {}/index.html
$buildindex out/index.html out/_index.html
echo "" | pandoc -s -f html -t html --data-dir="./" --template=templates/error.html --metadata title=- -o out/error.html

sass res/:out/res
