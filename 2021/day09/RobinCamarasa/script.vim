" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let g:input=[]
    normal! mm
    call execute('g/^.*$/normal! _"ly$:call add(g:input, @l)' . "\r")
    for i in range(len(g:input))
        let g:input[i] = split(g:input[i], '\zs')
    endfor
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
function! FindMin(grid)
    let n = len(a:grid)
    let m = len(a:grid[0])
    let risk = 0
    for i in range(n)
        for j in range(m)
            let adjacent = []
            for delta in [-1, 1]
                if (i + delta >= 0) && (i + delta < n)
                    call add(adjacent, 1 * a:grid[i + delta][j])
                endif
                if (j + delta >= 0) && (j + delta < m)
                    call add(adjacent, 1 * a:grid[i][j + delta])
                endif
            endfor
            if 1 * a:grid[i][j] < min(adjacent)
                let risk += a:grid[i][j] + 1
            endif
        endfor
    endfor
    return risk
endfunction

function! FindBassin(grid)
    let n = len(a:grid)
    let m = len(a:grid[0])
    let sizes = []
    for i in range(n)
        for j in range(m)
            let adjacent = []
            for delta in [-1, 1]
                if (i + delta >= 0) && (i + delta < n)
                    call add(adjacent, 1 * a:grid[i + delta][j])
                endif
                if (j + delta >= 0) && (j + delta < m)
                    call add(adjacent, 1 * a:grid[i][j + delta])
                endif
            endfor
            if 1 * a:grid[i][j] < min(adjacent)
                call add(sizes, len(RecurBassin(i, j, [], a:grid, n, m)))
            endif
        endfor
    endfor
    let sorted_sizes = sort(sizes, {a, b -> a < b})
    " return sorted_sizes
    return sorted_sizes[0] * sorted_sizes[1] * sorted_sizes[2]
endfunction

function! RecurBassin(i, j, bassin, grid, n, m)
    " Treat trivial cases
    if (a:i < 0) || (a:i >= a:n) || (a:j < 0) || (a:j >= a:m)
        return a:bassin
    endif
    if index(a:bassin, a:i . ',' . a:j) != -1
        return a:bassin
    endif
    if a:grid[a:i][a:j] == 9
        return a:bassin
    endif
    let g:bassin = copy(a:bassin)
    call add(g:bassin, a:i . ',' . a:j)
    for delta in [-1, 1]
        let g:bassin = RecurBassin(a:i + delta, a:j, g:bassin, a:grid, a:n, a:m)
        let g:bassin = RecurBassin(a:i, a:j + delta, g:bassin, a:grid, a:n, a:m)
    endfor
    return g:bassin
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    return "Solution 1: " . FindMin(input)
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    return "Solution 2: " . FindBassin(input)
endfunction
"}}}
