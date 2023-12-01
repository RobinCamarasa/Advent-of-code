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
function! EvaluateLine(line)
    let points = {')': 3, ']': 57, '}': 1197, '>': 25137}
    let opening = ['(', '[', '{', '<']
    let closing = [')', ']', '}', '>']
    let acc = []
    for c in a:line
        let ind = index(opening, c)
        if ind != -1
            call add(acc, opening[ind])
        else
            let indc = index(closing, c)
            if acc[-1] == opening[indc]
                let acc = acc[:-2]
            else
                return [acc, points[c]]
            endif
        endif
    endfor
    return [acc, 0]
endfunction

function! EvaluateAutocompletion(acc, score)
    if a:score != 0
        return 0
    endif
    let points = {'(': 1, '[': 2, '{': 3, '<': 4}
    let opening = ['(', '[', '{', '<']
    let sum = 0
    for i in range(len(a:acc) - 1, 0, -1)
        let sum = 5 * sum + points[a:acc[i]]
    endfor
    return sum
endfunction

"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    let sum = 0
    for line in input
        let sum += EvaluateLine(line)[1]
    endfor
    return "Solution 1: " . sum
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    let scores = []
    for line in input
        let eval = EvaluateLine(line)
        let score = EvaluateAutocompletion(eval[0], eval[1])
        if score != 0
            call add(scores, score)
        endif
    endfor
    let sorted_scores = sort(scores, {a, b -> a < b})
    return "Solution 2: " . sorted_scores[len(sorted_scores) / 2]
endfunction
"}}}
