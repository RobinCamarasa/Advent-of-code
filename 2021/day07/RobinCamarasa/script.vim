" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    normal! mm
    call execute('g/^.*$/normal! _"ly$:let g:input = split(@l, ",")' . "\r")
    for i in range(len(g:input))
        let g:input[i] *= 1
    endfor
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
function! GetOptimalNumber(positions, func)
    let max_position = max(a:positions)
    let previous_fuel = 0
    let min_fuel = a:func(max(a:positions)) * len(a:positions)
    let fuel = min_fuel
    for i in range(max_position)
        let previous_fuel = fuel
        let fuel = 0
        for position in a:positions
            let fuel += 1 * a:func(abs(position - i))
        endfor
        if previous_fuel - fuel <= 0
            return previous_fuel
        endif
    endfor
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    return "Solution 1: " . GetOptimalNumber(input, {i -> i})
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    return "Solution 2: " . GetOptimalNumber(input, {i -> (i*(i + 1)) / 2})
endfunction
"}}}
