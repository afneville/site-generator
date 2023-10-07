# Document Export Script

The build script used to build my _documentation_ website - an example
of how Pandoc and shell could be used to create a markdown blog. Other,
arguably better solutions include the [Hugo](https://gohugo.io/) and
[Jekyll](https://jekyllrb.com/) static site builders.

The `build.sh` script will automatically fetch the latest version of
[my documents](https://github.com/afneville/docs) and build an HTML
version in `out/`.

```sh
chmod u+x build.sh
./build.sh
```

## Requirements

- [Sass](https://sass-lang.com/install/)
- [Pandoc](https://pandoc.org/installing.html)
