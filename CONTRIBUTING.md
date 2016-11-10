# Running Pandoc

## Generating the Imaging Guide:
  See [Generating the Staff Guide](#staff_guide)

## Generating the Operators Guide:
  See [Generating the Staff Guide](#staff_guide)

## Generating the User Guide:
  See [Generating the Staff Guide](#staff_guide)

## Generating the Staff Guide:
  <a name="staff_guide"></a>

### Preparing to run pandoc

```
cd <directory_of_atmosphere_guides>/docs/staff_guide

# Copy CSS and Media  (if things have changed or first time run)
cp ../themes/cyverse/theme.css /opt/dev/atmosphere/init_files/theme.css
cp -r media /opt/dev/atmosphere/init_files/
```

### How to run Pandoc to generate an HTML file
```
pandoc --standalone -S --toc --toc-depth 4 -c ./themes/cyverse/templates/main.css --template templates/html/bootstrap.html docs/staff_guide/00_introduction/*.md docs/staff_guide/10_requests/*.md docs/staff_guide/20_instances/*.md docs/staff_guide/30_tools/*.md -t html -o ./staff_guide.html -A themes/cyverse/templates/footer.html -H themes/cyverse/templates/headers.html -B themes/cyverse/templates/header.html
```

### How to run Pandoc to generate a .docx file
Copy the lines above, skip the `-t html` line and insert this instead:

```
        -t docx -o ./staff_guide.docx
```

## How to Host the guides after generating the documents
  <a name="hosting_guide"></a>
To host the guide, copy these files into a static-folder directory hosted via Nginx/Apache:
```
    cp -r ./themes /path/to/www  # Ensures all of you're themes, css, etc. will be properly included
    cp -r ./staff_guide/media /path/to/www  # Ensures all related media will be properly included/referenced.
    cp ./staff_guide.html /path/to/www
```
