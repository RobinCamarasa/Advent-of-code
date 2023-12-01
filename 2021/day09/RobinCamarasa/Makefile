.PHONY: advent test

advent: README.md

README.md: advent.data script.vim
	vim -c "source script.vim | call WriteSolutions('README.md')" advent.data

test: test.md

test.md: test.data script.vim
	vim -c "source script.vim | call WriteSolutions('test.md')" test.data
