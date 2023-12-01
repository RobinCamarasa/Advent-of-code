" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let input=[]
    let folds=[]
    normal! mm
    call execute('g/^[0-9].*$/normal! _"ly$:call add(input, @l)' . "\r")
    call execute('g/^fold.*$/normal! $"xyiwbb"yyiw:call add(folds, [@y, 1 * @x])' . "\r")
    normal! `m
    return [input, folds]
endfunction
"}}}

" Utils {{{
function! InputToCoordinates(input)
    return map(split(a:input, ','), {id, val -> val})
endfunction

function! GetMaxIndices(input, index)
    return max(map(copy(a:input), {id, val -> 1 * split(val, ',')[a:index]})) + 1
endfunction

function! FoldFunction(val, fold)
    let val = copy(a:val)
    if a:fold[0] == 'x' && val[0] >= a:fold[1]
        return join([2 * a:fold[1] - val[0], val[1]], ',')
    endif
    if a:fold[0] == 'y' && val[1] >= a:fold[1]
        return join([val[0], 2 * a:fold[1] - val[1]], ',')
    endif
    return join(val, ',')
endfunction

function! ApplyFold(input, fold)
    return map(
                \map(
                    \copy(a:input), 
                    \{id, val -> InputToCoordinates(val)}
                \), 
            \{id, val -> FoldFunction(val, a:fold)}
        \)
endfunction

function! Display(input)
    let n = GetMaxIndices(a:input, 0)
    let m = GetMaxIndices(a:input, 1)
    let grid = []
    for i in range(m)
        let row = []
        for j in range(n)
            call add(row, '.')
        endfor
        call add(grid, row)
    endfor
    for inp in a:input
        let coor = InputToCoordinates(inp)
        let grid[1 * coor[1]][1 * coor[0]] = '#'
    endfor
    return join(map(copy(grid), {id, val -> join(copy(val), " ")}), "\n")
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    let parsing = Parse()
    return "Solution 1: " . len(uniq(sort(ApplyFold(parsing[0], parsing[1][0]))))
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let parsing = Parse()
    let input = parsing[0]
    let folds = parsing[1]
    for fold in parsing[1]
        let input = uniq(sort(ApplyFold(input, fold)))
    endfor
    return "Solution 2: \n```\n"  . Display(input) . "\n```"
endfunction
"}}}
