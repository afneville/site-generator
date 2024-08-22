in-dir := src
out-dir := out
tmp-dir := tmp
index-page-out := $(out-dir)/index.html
index-page-in := $(tmp-dir)/_index.html
error-page-out := $(out-dir)/error.html
res-out-dir := $(out-dir)/res
site-res-in-dir := $(in-dir)/res
static-res-dir := res

exclude := $(in-dir)/README% $(in-dir)/LICENSE% $(in-dir)/res
all-srcs := $(filter-out $(exclude),$(shell find $(in-dir) -name '*.md'))
articles-in := $(filter-out $(in-dir)/%/_contents.md,$(all-srcs))
articles-out := $(patsubst $(in-dir)/%.md,$(out-dir)/%.html,$(articles-in))
site-res-in := $(shell find $(site-res-in-dir) -mindepth 1)
site-res-out := $(patsubst $(in-dir)/%,$(out-dir)/%,$(site-res-in))
section-contents := $(filter $(in-dir)/%/_contents.md,$(all-srcs))
sections-sorted := $(shell echo $(dir $(section-contents)) | xargs -n1 basename | sort)
section-contents-sorted := $(foreach section,$(sections-sorted),$(filter $(in-dir)%$(section)/_contents.md,$(section-contents)))
sections-in := $(dir $(section-contents))
sections-out := $(patsubst $(in-dir)/%,$(out-dir)/%,$(sections-in))
directories-out := $(patsubst $(in-dir)/%,$(out-dir)/%,$(filter-out $(in-dir)/res%,$(shell find $(in-dir) -mindepth 1 -type d)))
sections-tmp := $(patsubst $(in-dir)/%,$(tmp-dir)/%,$(sections-in))
section-contents-tmp := $(patsubst $(in-dir)/%/_contents.md,$(tmp-dir)/%/_contents.md,$(section-contents))
section-indices := $(foreach section,$(directories-out),$(section)/index.html)
js-in := $(wildcard $(static-res-dir)/*.js)
js-out := $(patsubst $(static-res-dir)/%,$(res-out-dir)/%,$(js-in))
scss-in := $(wildcard $(static-res-dir)/*.scss)
css-out := $(res-out-dir)/style.css
static-res-in := $(static-res-dir)/fonts $(static-res-dir)/libs
static-res-out := $(patsubst $(static-res-dir)/%,$(res-out-dir)/%,$(static-res-in))

current_date := $$(date '+%Y-%m-%d')
current_time := $$(date '+%H:%M:%S')
current_commit := $$(git -C src rev-parse HEAD)
current_commit_short := $$(git -C src rev-parse --short HEAD)
command := pandoc -f markdown -t html -s
mathjax_flag  := --mathjax=https://cdn.afneville.com/mathjax/tex-svg.js
constant_flags := --data-dir=$$(pwd) --metadata-file=./res/metadata.yaml --lua-filter=res/md-to-html-links.lua --filter=pandoc-crossref --no-highlight
buildblogpost := $(command) $(constant_flags) $(mathjax_flag) --shift-heading-level-by=1 --template=templates/blog-post
buildindexsection := $(command) $(constant_flags) --template=templates/index-section
buildindex := $(command) $(constant_flags) --template=templates/index-page --metadata title=index --metadata date=$(current_date) --metadata time=$(current_time) --metadata commit=$(current_commit) --metadata shortcommit=$(current_commit_short) -o

.PHONY: clean

all: $(index-page-out) $(error-page-out) $(articles-out) $(section-indices) $(site-res-out) $(js-out) $(css-out)

$(index-page-out): $(index-page-in) templates/index-page.html templates/header.html templates/footer.html | $(out-dir)
	$(buildindex) $(index-page-out) $(index-page-in)

$(index-page-in): $(section-contents) templates/index-section.html | $(tmp-dir)
	-rm -f $(index-page-in)
	echo "<div id=\"pages\">" >$(index-page-in)
	for i in $(section-contents-sorted); do $(buildindexsection) $$i >> $(index-page-in); done
	echo "</div>" >>$(index-page-in)

$(error-page-out): templates/error.html templates/header.html templates/footer.html | $(out-dir)
	echo "" | pandoc -s -f html -t html --data-dir="./" --template=$< --metadata title=- -o $@

.SECONDEXPANSION:
$(articles-out): $(out-dir)/%.html: $(in-dir)/%.md $(tmp-dir)/$$(dir %)_contents.md templates/blog-post.html templates/header.html templates/footer.html templates/see-also.md templates/back.md | $(sections-out)
	echo $(patsubst $(out-dir)/%,%,$@)
	$(buildblogpost) --metadata filepath=$(patsubst $(out-dir)/%,%,$@) -o $@ $< templates/see-also.md $(patsubst %/,$(tmp-dir)/%/_contents.md,$(dir $(patsubst $(out-dir)/%,%,$@))) templates/back.md

$(site-res-out): $(res-out-dir)/%: $(site-res-in-dir)/% | $(res-out-dir)
	cp -r $(site-res-in-dir)/* $(res-out-dir)

$(js-out): $(res-out-dir)/%.js: $(static-res-dir)/%.js | $(res-out-dir)
	cp $< $@

$(css-out): $(scss-in) | $(res-out-dir)
	sass $(static-res-dir):$(res-out-dir)

$(section-contents-tmp): $(tmp-dir)/%/_contents.md: $(in-dir)/%/_contents.md | $(tmp-dir) $(sections-tmp)
	tail -n +5 $< > $@

$(section-indices): templates/redirect.html | $(sections-out)
	cp $< $@

# $(static-res-out) : $(static-res-in) | $(res-out-dir)
# 	cp -r $(static-res-in) $(res-out-dir)

$(res-out-dir) : | $(out-dir)
	mkdir -p $@
	cp -r $(static-res-in) $@

$(sections-out) : | $(out-dir)
	mkdir -p $@

$(sections-tmp) : | $(tmp-dir)
	mkdir -p $@

$(out-dir):
	mkdir -p $@

$(tmp-dir):
	mkdir -p $@

clean:
	-rm -rf $(out-dir)
	-rm -rf $(tmp-dir)
