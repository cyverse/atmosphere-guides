.DEFAULT_GOAL = all
.PHONY = all clean themes media

all: build_html

dist:
	mkdir dist

themes: dist
	rsync -avh themes dist

media: dist
	rsync -avh media dist

build_html: dist themes media
	./scripts/to_html_template.sh index getting_started guacamole_administration guacamole_user_guide install_guide staff_guide user_guide imaging_guide connecting_cloud_provider project_contribution_guide code_guidelines atmosphere_troubleshooting_guide openstack_troubleshooting_guide gateone_background

clean:
	rm -r dist
