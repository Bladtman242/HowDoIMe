.PHONY: sync all

.DEFAULT_GOAL := all

sources=$(patsubst %.mkdn,out/%.html, $(wildcard exmkdn/*.mkdn))

all: $(sources)

out/%.html: %.mkdn pandoc.html.format
	pandoc -Ss --highlight-style zenburn -o $@ $< --template pandoc.html.format

sync: $(all)
	docker run -it -v $$PWD/out:/home/aws/out -v $$PWD/aws:/home/aws/.aws fstab/aws-cli bash -c "source /home/aws/aws/env/bin/activate; aws s3 sync out s3://www.howdoi.me --acl public-read"
