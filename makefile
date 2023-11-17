in-dir := src
out-dir := out
tmp-dir := tmp
index-page-out := $(out-dir)/index.html
index-page-in := $(tmp-dir)/_index.html
error-page-out := $(out-dir)/error.html
res-out-dir := $(out-dir)/res
site-res-in-dir := $(in-dir)/res
static-res-dir := res

articles-in := $(filter-out $(in-dir)/%/_contents.md,$(wildcard $(in-dir)/**/*.md))
articles-out := $(patsubst $(in-dir)/%.md,$(out-dir)/%.html,$(articles-in))
site-res-in := $(wildcard $(site-res-in-dir)/**/*)
site-res-out := $(patsubst $(in-dir)/%,$(out-dir)/%,$(site-res-in))
section-contents := $(filter $(in-dir)/%/_contents.md,$(wildcard $(in-dir)/**/*.md))
exclude := $(in-dir)/README% $(in-dir)/LICENSE% $(in-dir)/res
sections-in := $(filter-out $(exclude),$(wildcard $(in-dir)/*))
sections-out := $(patsubst $(in-dir)/%,$(out-dir)/%,$(sections-in))
sections-tmp := $(patsubst $(in-dir)/%,$(tmp-dir)/%,$(sections-in))
section-contents-tmp := $(patsubst $(in-dir)/%/_contents.md,$(tmp-dir)/%.md,$(section-contents))
section-indices := $(foreach section,$(sections-out),$(section)/index.html)
js-in := $(wildcard $(static-res-dir)/*.js)
js-out := $(patsubst $(static-res-dir)/%,$(res-out-dir)/%,$(js-in))
scss-in := $(wildcard $(static-res-dir)/*.scss)
css-out := $(res-out-dir)/style.css


current_date := $$(date '+%Y-%m-%d')
current_time := $$(date '+%H:%M:%S')
current_commit := $$(git -C src rev-parse HEAD)
current_commit_short := $$(git -C src rev-parse --short HEAD)
command := pandoc -f markdown -t html -s
mathjax_flag  := --mathjax=https://cdn.afneville.com/mathjax/tex-svg.js
constant_flags := --data-dir=$$(pwd) --metadata-file=./res/metadata.yaml --lua-filter=res/md-to-html-links.lua --filter=pandoc-crossref --no-highlight
buildblogpost := $(command) $(constant_flags) $(mathjax_flag) --shift-heading-level-by=1 --template=templates/blog-post -o
buildindexsection := $(command) $(constant_flags) --template=templates/index-section
buildindex := $(command) $(constant_flags) --template=templates/index-page --metadata title=index --metadata date=$(current_date) --metadata time=$(current_time) --metadata commit=$(current_commit) --metadata shortcommit=$(current_commit_short) -o

.PHONY: clean

all: $(index-page-out) $(error-page-out) $(articles-out) $(section-indices) $(site-res-out) $(js-out) $(css-out)

$(index-page-out): $(index-page-in) | $(out-dir)
	$(buildindex) $(index-page-out) $(index-page-in)

$(index-page-in): $(section-contents) | $(tmp-dir)
	-rm -f $(index-page-in)
	echo "<div id=\"pages\">" >$(index-page-in)
	for i in $(section-contents); do $(buildindexsection) $$i >> $(index-page-in); done
	echo "</div>" >>$(index-page-in)

$(error-page-out): templates/error.html | $(out-dir)
	echo "" | pandoc -s -f html -t html --data-dir="./" --template=$< --metadata title=- -o $@

.SECONDEXPANSION:
$(articles-out): $(out-dir)/%.html: $(in-dir)/%.md $(tmp-dir)/$$(firstword $$(subst /, ,%)).md | $(sections-out)
	$(buildblogpost) $@ $< templates/see-also.md $(patsubst %/,$(tmp-dir)/%.md,$(dir $(patsubst $(out-dir)/%,%,$@))) templates/back.md

$(site-res-out): $(res-out-dir)/%: $(site-res-in-dir)/% | $(res-out-dir)
	cp -r $(site-res-in-dir)/* $(res-out-dir)

$(js-out): $(res-out-dir)/%.js: $(static-res-dir)/%.js | $(res-out-dir)
	cp $< $@

$(css-out): $(scss-in) | $(res-out-dir)
	sass $(static-res-dir):$(res-out-dir)

$(section-contents-tmp): $(tmp-dir)/%.md: $(in-dir)/%/_contents.md | $(tmp-dir)
	tail -n +5 $< > $@

$(section-indices): templates/redirect.html | $(sections-out)
	cp $< $@

$(res-out-dir) : | $(out-dir)
	mkdir -p $@

$(sections-out) : | $(out-dir)
	mkdir -p $@

$(out-dir):
	mkdir -p $@

$(tmp-dir):
	mkdir -p $@


clean:
	-rm -rf $(out-dir)
	-rm -rf $(tmp-dir)
