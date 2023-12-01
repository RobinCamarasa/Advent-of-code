" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    normal! mm
    call execute('g/^.*$/normal! _"ly$:let g:input=split(@l, ",")' . "\r")
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
function! InputToList(input)
    let g:list = []
    for i in range(9)
        call add(g:list, 0)
    endfor
    for item in a:input
        let g:list[item] += 1
    endfor
    return g:list
endfunction

function! ComputeNextDay(input)
    let new_born = a:input[0]
    let g:list = copy(a:input)[1:] + [new_born]
    let g:list[6] += new_born
    return g:list
endfunction

function! Sum(input)
    let sum = 0
    for item in a:input
        let sum += item
    endfor
    return sum
endfunction

function GetNbFish(list, days)
    let list = InputToList(Parse())
    for i in range(a:days)
        let list = ComputeNextDay(list)
    endfor
    return Sum(list)
endfunction

"}}}

" Part One {{{
function! SolvePartOne()
    return "Solution 1: " . GetNbFish(InputToList(Parse()), 80)
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    return "Solution 2: " . GetNbFish(InputToList(Parse()), 256)
endfunction
"}}}
