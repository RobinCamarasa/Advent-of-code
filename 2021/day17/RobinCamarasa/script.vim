" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let g:input=[]
    normal! mm
    call execute('g/^.*$/normal! t=ll"ayt,t=ll"by$:call add(g:input, map([@a, @b], {id, val -> map(split(val,  ''\.\.'')}, {id2, val2 -> 1 * val2})))' . "\r")
    

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
