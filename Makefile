.DEFAULT_GOAL = all
.PHONY = all clean

all: build_html

commit: build_html gh-pages-commit


gh-pages-commit:
	git subtree push --prefix dist origin gh-pages

build_html:
	./scripts/to_html_template.sh index install_guide staff_guide user_guide imaging_guide connecting_cloud_provider contributing_to_atmosphere troubleshooting_guide
