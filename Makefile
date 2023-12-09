.PHONY: day resources start

DAY = $(shell date -u +%d)
YEAR = $(shell date -u +%Y)
USER = RobinCamarasa

SESSION := $(AOC_COOKIE)
DAYDIR := $(YEAR)/day$(DAY)
DIR := $(YEAR)/day$(DAY)/$(USER)
 
day: resources copy
	mkdir -p "$(DIR)/data"
	curl "https://adventofcode.com/$(YEAR)/day/$(shell echo $(DAY) | sed -e 's/^0//g')/input" -H "cookie: ${SESSION}" -o  "$(DIR)/data/data.txt"
	touch "$(DIR)/data/test.txt"

copy:
	echo "https://adventofcode.com/$(YEAR)/day/$(shell echo $(DAY) | sed -e 's/^0//g')" | xsel -ib

resources: copy
	mkdir -p $(YEAR)/day$(DAY)
	cp -r resources/$(YEAR) $(DIR)

start: copy
	test -d "$(DIR)" && echo 'already exists' || make day DAY='$(DAY)' YEAR='$(YEAR)' USER='$(USER)'; cd "$(DIR)"; nvim ./

show:
	less README.md
