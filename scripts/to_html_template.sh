#!/bin/bash


###
# Variable declarations settable *OUTSIDE* the script
###
if [ -z "$THEME_NAME" ]; then
  THEME_NAME="cyverse"
fi
#NOTE: THEME_PATH is *ALWAYS* relative to the dist/ directory --
if [ -z "$THEME_PATH" ]; then
  THEME_PATH="./themes/$THEME_NAME"
fi

###
# Call to generate static HTML based on pandoc
###
function run_pandoc {
    # NOTE -c (css) is missing ./dist is *intended*
    pandoc \
        $MD_FILES\
        --template "templates/html/bootstrap.html"\
        -B "$THEME_PATH/templates/header.html"\
        -H "$THEME_PATH/templates/headers.html"\
        -A "$THEME_PATH/templates/footer.html"\
        -c "$THEME_PATH/templates/main.css"\
        --standalone -smart --toc --toc-depth 4\
        -t "html" -o "./dist/${SECTION}.html"
}

function main {
    if [ -z "$1" ]; then
      echo "Error:No section name given."
      echo "Usage: $0 section_name [section_name] ..."
      exit 1
    fi

    for SECTION in "$@"
    do
        MD_FILES=`find "src/${SECTION}/" -name "*.md" | sort | tr '\n' ' '`
        run_pandoc
    done
}

main "$@"
