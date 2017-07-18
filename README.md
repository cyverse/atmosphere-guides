# Atmosphere Guides [![Build Status](https://travis-ci.org/cyverse/atmosphere-guides.svg?branch=master)](https://travis-ci.org/cyverse/atmosphere-guides)

This repo contains multiple guides that are hosted on Github Pages:
[https://cyverse.github.io/atmosphere-guides](https://cyverse.github.io/atmosphere-guides).


## How to Contribute

### How to Install


#### Mac OS X

You can install the released `.dmg` built as part of Pandoc releases. You can find them on the [release page](https://github.com/jgm/pandoc/releases/latest).

Or, you can install via [Homebrew](https://brew.sh/):

```
brew install pandoc
```

More details are available on the Pandoc [installing page](http://pandoc.org/installing.html#mac-os-x).

#### Linux

For Linux, the suggestion is to try using the distributions package manager.

The Atmosphere development team favors Ubuntu, here is an example of installed within that distribution:

```
$ sudo apt-get install pandoc
```

This will install `pandoc` and `pandoc-data`.

More details are available on the Pandoc [installing page](http://pandoc.org/installing.html#linux).


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
Static HTML is served on [GitHub Pages](https://pages.github.com/) from the `gh-pages` branch of this repository, which contains only the `dist/` folder of the master branch. After pushing changes to master or merging in a pull request, the gh-pages branch will be automatically updated by the Travis CI [deployment provider for GitHub Pages](https://docs.travis-ci.com/user/deployment/pages/). 

Note: if a manual push to `gh-pages` is required, a maintainer (someone with write access) can do this by running `make gh-pages-commit` from a local copy of this repository.


### Notice for CyVerse Documenters
A lot of Atmosphere documentation lives on the [CyVerse Wiki](https://pods.iplantcollaborative.org/wiki/dashboard.action), some in the [Atmosphere Manual](https://pods.iplantcollaborative.org/wiki/display/atmman/Atmosphere+Manual+Table+of+Contents) and some in private spaces. Going forward, documentation should be maintained as follows:

- Docs for Atmosphere(1) as *the open-source platform for cloud computing* should be hosted here on [atmosphere-guides](https://cyverse.github.io/atmosphere-guides), and what exists on the CyVerse wiki should be migrated here.
- Docs for Atmosphere(0) as *CyVerse's cloud computing service for bioscience research* should remain on the CyVerse wiki, in [Atmosphere Manual](https://pods.iplantcollaborative.org/wiki/display/atmman/Atmosphere+Manual+Table+of+Contents) or other spaces as appropriate.

When you do migrate content from the CyVerse wiki to atmosphere-guides, please *remove the content from the wiki* and *leave a link to the new guide in its place*. This way, we avoid maintaining parallel documentation on multiple platforms, while helping others find information in its new location.
