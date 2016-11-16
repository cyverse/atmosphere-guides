# Atmosphere Guides

This repo contains multiple guides that are hosted on Github Pages:
[https://cyverse.github.io/atmosphere-guides](https://cyverse.github.io/atmosphere-guides).

## Guides Overview

### User Guide

This guide will explain how Atmosphere works from the perspective of the End
User. (Don't mention Troposphere or other jargon for the End User).

### Staff Guide

This guide will explain how Atmosphere works from the perspective of a Staff
user (With Admin privileges)

### Imaging Guide

This guide will contain handy information for End Users looking to create new
images.

## How to Contribute

See CONTRIBUTING.md for more details not covered here.

### How to Write Docs
Guides are written in Markdown. You may want to use a tool to render your Markdown. [livedown](https://github.com/shime/livedown) works with a few editors to hot-load your changes.

Here is another tool to make nice GIFs.
http://recordit.co/

### How to Compile Docs
After making changes, you need to compile them (so they will show up in GitHub Pages).

To do this, cd to this directory and run:
```
make
```

If you create a new guide, you will need to update the Makefile so that `to_html_template.sh` builds HTML for your new guide.

## Notes for CyVerse Document writers
Don't forget to dog food the existing wiki, It is *verbose* and was actually kept up to date for a long period of time.

https://pods.iplantcollaborative.org/wiki/display/atmman/Atmosphere+Manual+Table+of+Contents


