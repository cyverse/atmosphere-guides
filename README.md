# Atmosphere Guides

This repo contains multiple guides that are hosted on Github Pages:
[https://cyverse.github.io/atmosphere-guides](https://cyverse.github.io/atmosphere-guides).

## How to Contribute

### How to Write Docs
Guides are written in Markdown. You may want to use a tool to render your Markdown. [livedown](https://github.com/shime/livedown) works with a few editors to hot-load your changes. The [atom](https://atom.io/) editor also has built-in markdown preview.

Here is another tool to make nice GIFs.
http://recordit.co/

### How to Publish Docs
After making changes to the Markdown source, you need to compile them to HTML, then push to the gh-pages branch, from which the static HTML is served.

#### Compiling Docs
First, you must have [pandoc](http://pandoc.org/) installed and in your executable path -- see [Installing Pandoc](http://pandoc.org/installing.html).

If you create a new guide, you will also need to update the Makefile so that `to_html_template.sh` builds HTML for your new guide.

Finally, to compile the docs, run `make` from the root of this repository.

See CONTRIBUTING.md for Pandoc-specific details not covered here.

#### Pushing to GitHub Pages
Static HTML is served on [GitHub Pages](https://pages.github.com/) from the `gh-pages` branch of this repository, which contains only the `dist/` folder of the master branch. After pushing changes to master or merging in a pull request, the gh-pages branch must be updated. A maintainer (someone with write access) can do this by running `make gh-pages-commit` from a local copy of this repository.

### Notice for CyVerse Documenters
A lot of Atmosphere documentation lives on the [CyVerse Wiki](https://pods.iplantcollaborative.org/wiki/dashboard.action), some in the [Atmosphere Manual](https://pods.iplantcollaborative.org/wiki/display/atmman/Atmosphere+Manual+Table+of+Contents) and some in private spaces. Going forward, documentation should be maintained as follows:

- Docs for Atmosphere(1) as *the open-source platform for cloud computing* should be hosted here on [atmosphere-guides](https://cyverse.github.io/atmosphere-guides), and what exists on the CyVerse wiki should be migrated here.
- Docs for Atmosphere(0) as *CyVerse's cloud computing service for bioscience research* should remain on the CyVerse wiki, in [Atmosphere Manual](https://pods.iplantcollaborative.org/wiki/display/atmman/Atmosphere+Manual+Table+of+Contents) or other spaces as appropriate.

When you do migrate content from the CyVerse wiki to atmosphere-guides, please *remove the content from the wiki* and *leave a link to the new guide in its place*. This way, we avoid maintaining parallel documentation on multiple platforms, while helping others find information in its new location.
