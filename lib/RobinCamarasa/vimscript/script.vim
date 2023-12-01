" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let g:input=[]
    normal! mm
    call execute('g/^.*$/normal! _"ly$:call add(g:input, {"line": @l})' . "\r")
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    return "Solution 1"
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    return "Solution 2"
endfunction
"}}}
