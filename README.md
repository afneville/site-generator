# Export Markdown Documents to HTML

The components required to build
[my documentation website](https://docs.afneville.com) - an example of
how Pandoc, make and shell could be used to create a markdown blog.
Other, arguably better solutions include the [Hugo](https://gohugo.io/)
and [Jekyll](https://jekyllrb.com/) static site builders.

To fetch the source markdown documents [from here](https://github.com/afneville/docs) and build the site under `out/`,
run:

```sh
git submodule update --init --remote --recursive
make
```

## Requirements

- [Sass](https://sass-lang.com/install/)
- [Pandoc](https://pandoc.org/installing.html)
