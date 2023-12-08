.PHONY: day resources start

DAY = $(shell date -u +%d)
YEAR = $(shell date -u +%Y)
USER = RobinCamarasa

SESSION := $(AOC_COOKIE)
DAYDIR := $(YEAR)/day$(DAY)
DIR := $(YEAR)/day$(DAY)/$(USER)
 
day: resources
	mkdir -p "$(DIR)/data"
	curl "https://adventofcode.com/$(YEAR)/day/$(shell echo $(DAY) | sed -e 's/^0//g')/input" -H "cookie: ${SESSION}" -o  "$(DIR)/data/data.txt"
	touch "$(DIR)/data/test.txt"
	echo "https://adventofcode.com/$(YEAR)/day/$(shell echo $(DAY) | sed -e 's/^0//g')" | xsel -ib

resources:
	mkdir -p $(YEAR)/day$(DAY)
	cp -r resources/$(YEAR) $(DIR)

start:
	test -d "$(DIR)" && echo 'already exists' || make day DAY='$(DAY)' YEAR='$(YEAR)' USER='$(USER)'; cd "$(DIR)"; nvim ./

show:
	less README.md
