.PHONY: sync all

.DEFAULT_GOAL := all

source_files=$(shell find source -type f -name '*.mkdn')

# replicate source/ folder structure in out/, and copy non-markdown files
# (assets) into out
$(shell cd source; rsync -r --exclude '*.mkdn' . ../out/)

dest_files=$(patsubst source/%.mkdn,out/%.html, $(source_files))

all: $(dest_folders) $(dest_files)

out/%.html: source/%.mkdn pandoc.html.format
	pandoc -Ss -f markdown+footnotes --highlight-style zenburn -o $@ $< --template pandoc.html.format

sync: $(all)
	docker run -it -v $$PWD/out:/home/aws/out -v $$PWD/aws:/home/aws/.aws fstab/aws-cli bash -c "source /home/aws/aws/env/bin/activate; aws s3 sync out s3://www.howdoi.me --acl public-read"
