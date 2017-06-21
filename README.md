# github-markdown-preview

Docker to run github-markdown-preview with syntax highlighting installed.

## Usage

Converts all images in current directory (using a script called `github-markdown-render`)

```
USER_ID=`id -u` GROUP_ID=`id -g` \
  docker-compose run github-markdown-preview
```

Convert all images in another directory

```
USER_ID=`id -u` GROUP_ID=`id -g` SRC_DIR={some_other_dir} OUT_DIR={some_other_dir}\
  docker-compose run github-markdown-preview
```

Convert images in a dir without docker-compose

```
docker run -it --rm -e DOCKER_USER_ID=`id -u` -e DOCKER_GROUP_ID=`id -g` \
           -v {markdown_dir}:/src:ro -v {output_dir}:/out \
           andyneff/github-markdown-preview
```

Call the original `github-markdown-preview` program

```
USER_ID=`id -u` GROUP_ID=`id -g` \
  docker-compose run github-markdown-preview github-markdown-preview /out/README.md
```

## Known bugs

It currently prints out the harmless warning:

```
/usr/local/bundle/gems/nokogiri-1.6.5/lib/nokogiri/html/document.rb:164: warning: constant ::Fixnum is deprecated
/usr/local/bundle/gems/nokogiri-1.6.5/lib/nokogiri/xml/node.rb:521: warning: constant ::Fixnum is deprecated
```

## References

 - [Original image](https://github.com/docker-rubygem/github-markdown-preview)