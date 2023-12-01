" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let g:input=[]
    normal! mm
    call execute('g/^.*$/normal! _"iyiw$"vyiw:call add(g:input, {"instruction": @i, "value": @v})' . "\r")
    
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    let depth = 0
    let horizontal = 0
    for instruction in input
        if instruction['instruction'] == "forward"
            let horizontal += instruction['value']
        elseif instruction['instruction'] == "up"
            let depth -= instruction['value']
        else
            let depth += instruction['value']
        endif
    endfor
    return "Solution 1: " . depth * horizontal
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    let depth = 0
    let horizontal = 0
    let aim = 0
    for instruction in input
        if instruction['instruction'] == "forward"
            let horizontal += instruction['value']
            let depth += aim * instruction['value']
        elseif instruction['instruction'] == "up"
            let aim -= instruction['value']
        else
            let aim += instruction['value']
        endif
    endfor
    return "Solution 2: " . depth * horizontal
endfunction
"}}}
