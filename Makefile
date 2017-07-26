.DEFAULT_GOAL = all
.PHONY = all clean

all: build_html

commit: build_html gh-pages-commit


gh-pages-commit:
	git subtree push --prefix dist origin gh-pages

build_html:

	./scripts/to_html_template.sh index getting_started install_guide staff_guide user_guide imaging_guide connecting_cloud_provider project_contribution_guide code_guidelines atmosphere_troubleshooting_guide openstack_troubleshooting_guide gateone_background