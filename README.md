# Static Site Generator

This repository contains the components required to build
[my documentation website](https://docs.afneville.com), by using Pandoc
to convert [my markdown documents](https://github.com/afneville/docs) to
HTML.

This solution precisely meets my own requirements. More mature and
flexible solutions include the [Hugo](https://gohugo.io/) and
[Jekyll](https://jekyllrb.com/) static site generators.

To generate the website in the `out/` directory:

```sh
git submodule update --init --remote --recursive
make
```

## Requirements

- [Sass](https://sass-lang.com/install/)
- [Pandoc](https://pandoc.org/installing.html)
- [Make](https://www.gnu.org/software/make/)
