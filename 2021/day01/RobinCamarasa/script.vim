" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let g:input=[]
    normal! mm
    call execute('g/^.*$/normal! _"ly$:call add(g:input, @l)' . "\r")
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    let previous_depth = -1
    let counter = -1
    for line in input 
        if line - previous_depth > 0
            let counter += 1
        endif
        let previous_depth = line
    endfor
    return "Solution 1: " . counter
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    let previous_value = 0
    let counter = -1
    for i in range(len(input) - 2)
        let value = input[i] + input[i+1] + input[i+2]
        if previous_value - value < 0
            let counter += 1
        endif
        let previous_value = value
    endfor
    return "Solution 2: " . counter
endfunction
"}}}
