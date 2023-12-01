" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let g:input=[]
    normal! mm
    call execute('g/^.*$/normal! _"ly$:call add(g:input, split(@l, "|"))' . "\r")
    for i in range(len(g:input))
        let g:input[i] = [split(g:input[i][0], ' '), split(g:input[i][1], ' ')]
    endfor
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
function! SortString(string)
    return join(sort(split(a:string, '\zs')), '-')
endfunction

function! GetMapping(signals)
    let g:mapping = {}
    let g:inversed_mapping = {}

    " Get easy cases
    for signal in a:signals
        let sorted_string = SortString(signal)
        if len(signal) == 2
            let g:mapping[sorted_string] = 1
            let g:inversed_mapping[1] = sorted_string
        elseif len(signal) == 3
            let g:mapping[sorted_string] = 7
            let g:inversed_mapping[7] = sorted_string
        elseif len(signal) == 4
            let g:mapping[sorted_string] = 4
            let g:inversed_mapping[4] = sorted_string
        elseif len(signal) == 7
            let g:mapping[sorted_string] = 8
            let g:inversed_mapping[8] = sorted_string
        endif
    endfor

    " To get 9 we observe that it is the only remaining number of 6 segments
    " that contains the segments of the 4
    for signal in a:signals
        let sorted_string = SortString(signal)
        if (has_key(g:mapping, sorted_string) == 0) && (len(signal) == 6)
            let is_in = 0
            for i in range(0, len(g:inversed_mapping[4]) - 1, 2)
                if index(split(sorted_string, '-'), g:inversed_mapping[4][i]) != -1
                    let is_in += 1
                endif
                if is_in == 4
                    let g:mapping[sorted_string] = 9
                    let g:inversed_mapping[9] = sorted_string
                endif
            endfor
        endif
    endfor

    " To get 0 we observe that it is the only remaining number of 6 segments
    " that contains the segments of the 1
    for signal in a:signals
        let sorted_string = SortString(signal)
        if (has_key(g:mapping, sorted_string) == 0) && (len(signal) == 6)
            let is_in = 0
            for i in range(0, len(g:inversed_mapping[1]) - 1, 2)
                if index(split(sorted_string, '-'), g:inversed_mapping[1][i]) != -1
                    let is_in += 1
                endif
                if is_in == 2
                    let g:mapping[sorted_string] = 0
                    let g:inversed_mapping[0] = sorted_string
                endif
            endfor
        endif
    endfor

    " The remaining 6 segments number is the 6
    for signal in a:signals
        let sorted_string = SortString(signal)
        if (has_key(g:mapping, sorted_string) == 0) && (len(signal) == 6)
            let g:mapping[sorted_string] = 6
            let g:inversed_mapping[6] = sorted_string
        endif
    endfor

    " To get 3 we observe that it is the only remaining number of 5 segments
    " that contains the segments of the 1
    for signal in a:signals
        let sorted_string = SortString(signal)
        if (has_key(g:mapping, sorted_string) == 0) && (len(signal) == 5)
            let is_in = 0
            for i in range(0, len(g:inversed_mapping[1]) - 1, 2)
                if index(split(sorted_string, '-'), g:inversed_mapping[1][i]) != -1
                    let is_in += 1
                endif
                if is_in == 2
                    let g:mapping[sorted_string] = 3
                    let g:inversed_mapping[3] = sorted_string
                endif
            endfor
        endif
    endfor

    " To get 5 we observe that it is the only remaining number of 5 segments
    " that are all contained in 9
    for signal in a:signals
        let sorted_string = SortString(signal)
        if (has_key(g:mapping, sorted_string) == 0)
            let is_in = 0
            for i in range(0, len(g:inversed_mapping[9]) - 1, 2)
                if index(split(sorted_string, '-'), g:inversed_mapping[9][i]) != -1
                    let is_in += 1
                endif
                if is_in == 5
                    let g:mapping[sorted_string] = 5
                    let g:inversed_mapping[5] = sorted_string
                endif
            endfor
        endif
    endfor

    " The remaining number is 2
    for signal in a:signals
        let sorted_string = SortString(signal)
        if (has_key(g:mapping, sorted_string) == 0)
            let g:mapping[sorted_string] = 2
            let g:inversed_mapping[2] = sorted_string
        endif
    endfor

    return g:mapping

endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    let easy_num = [2, 3, 4, 7]
    let nb_easy_num = 0
    let input = Parse()
    for signals in input
        for signal in signals[1]
            if index(easy_num, len(signal)) != -1
                let nb_easy_num += 1
            endif
        endfor
    endfor
    return "Solution 1: " . nb_easy_num
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    let sum = 0
    for signals in input
        let mapping = GetMapping(signals[0])
        let output = 0
        for signal in signals[1]
            let output = 10 * output + mapping[SortString(signal)]
        endfor
        let sum += output
    endfor
    return "Solution 2: " . sum
endfunction
"}}}
