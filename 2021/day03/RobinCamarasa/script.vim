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
function! ToBin(list)
    let g:total = 0
    for i in range(len(a:list))
        let g:total = 2 * g:total + a:list[i]
    endfor
    return g:total

endfunction

function! BitCriteria(input, currentbit, isoxygen)
    let ones = []
    let zeros = []
    for entry in a:input
        if entry[a:currentbit] - 1 == 0
            call add(ones, entry)
        else
            call add(zeros, entry)
        endif
    endfor
    let isonesmax = len(ones) - len(zeros) >= 0
    if a:isoxygen * isonesmax + (1 - a:isoxygen) * (1 - isonesmax)
        return ones
    else
        return zeros
    endif
endfunction

function! GetValue(input, isoxygen)
    let g:list = copy(a:input)
    for i in range(len(g:list))
        if len(g:list) - 1 > 0
            let g:list = BitCriteria(g:list, i, a:isoxygen)
        else
            return ToBin(g:list[0])
        endif
    endfor
    return ToBin(g:list[0])
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    let ones = []
    let zeros = []
    let most = []
    let least = []
    for i in range(len(input[1]))
        call add(ones, 0) 
        call add(zeros, 0) 
        call add(most, 0) 
        call add(least, 0) 
    endfor
    for entry in input
        for i in range(len(entry))
            if entry[i] - 1 == 0
                let ones[i] += 1
            else
                let zeros[i] += 1
            endif
        endfor
    endfor
    for i in range(len(ones))
        if ones[i] - zeros[i] > 0
            let most[i] = 1
            let least[i] = 0
        else
            let most[i] = 0
            let least[i] = 1
        endif
    endfor
    let gamma = ToBin(most)
    let epsilon = ToBin(least)
    return "Solution 1: " . gamma * epsilon
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let g:input = Parse()
    let oxygen = GetValue(g:input, 1)
    let co2 = GetValue(g:input, 0)
    return "Solution 2: " . oxygen * co2
endfunction
"}}}
