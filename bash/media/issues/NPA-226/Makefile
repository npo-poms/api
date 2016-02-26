
SHELL := /bin/bash
ITERATE=../../iterate.sh

.PHONY: all clean
.PRECIOUS: %.localhost.txt %.prod.txt %.localhost.mids.txt %.prods.mids.txt

all: vpro.diff npodoc.diff
	wc -l vpro.* npodoc.*

%.localhost.txt:
	ENV=localhost  $(ITERATE) 1000000 $*  | jsongrep -sortfields false -output FULLVALUE -recordsep $$'\n\n' -record mediaobjects[*] mediaobjects[*].mid,mediaobjects[*].objectType,mediaobjects[*].locations.*.programUrl,mediaobjects[*].locations.*.platform | tee $@

%.prod.txt:
	ENV=prod  $(ITERATE) 1000000 $*  | jsongrep -sortfields false -output FULLVALUE -recordsep $$'\n\n' -record mediaobjects[*] mediaobjects[*].mid,mediaobjects[*].objectType,mediaobjects[*].locations.*.programUrl,mediaobjects[*].locations.*.platform | tee $@


%.prod.mids.txt: %.prod.txt
	grep -E  '^$$' -A 2 $<   | grep -v -E "^$$" | grep -v -E "^--$$" | grep -v -E "^(program|segment|group)$$" | sort -u > $@

%.localhost.mids.txt: %.localhost.txt
	grep -E  '^$$' -A 2 $<   | grep -v -E "^$$" | grep -v -E "^--$$" | grep -v -E "^(program|segment|group)$$" | sort -u > $@

%.diff: %.prod.mids.txt %.localhost.mids.txt
	diff --new-line-format="" --unchanged-line-format=""  $*.prod.mids.txt $*.localhost.mids.txt   2>/dev/null > $@ ; test $$? -le 1

clean:
	rm -rf *.diff *.localhost.mids.txt *.prod.mids.txt
