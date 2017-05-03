.PHONY: sync all

.DEFAULT_GOAL := all

source_files := $(shell find source -type f -name '*.mkdn')
source_assets := $(shell find source -type f -not -name '*.mkdn')

# replicate source/ folder structure in out/
$(shell cd source; find * -type d -not -empty -exec mkdir -p ../out/'{}' \;)

dest_files := $(patsubst source/%.mkdn,out/%.html, $(source_files))
dest_assets := $(patsubst source/%,out/%, $(source_assets))

all: $(dest_files) $(dest_assets)

#assets
out/%: source/%
	cp -a $< $@

#markdown posts
out/%.html: source/%.mkdn pandoc.html.format
	pandoc -Ss -f markdown+footnotes --highlight-style zenburn -o $@ $< --template pandoc.html.format

sync: $(all)
	docker run -it -v $$PWD/out:/home/aws/out -v $$PWD/aws:/home/aws/.aws fstab/aws-cli bash -c "source /home/aws/aws/env/bin/activate; aws s3 sync out s3://www.howdoi.me --acl public-read"
