" Import {{{
" Note that without this option the program crashes
" Maybe a sign that vimscrip is not truly made for this exercice
set maxfuncdepth=200
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let g:input=[]
    normal! mm
    call execute('g/^.*$/normal! _"ly$:call add(g:input, split(@l, ''\zs''))' . "\r")
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
function! Flash(grid, i, j, n)
    let grid = copy(a:grid)
    let grid[a:i][a:j] = -1
    for i in [a:i-1, a:i, a:i+1]
        for j in [a:j-1, a:j, a:j+1]
            let grid = Update(grid, i, j, a:n)
        endfor
    endfor
    return grid
endfunction

function! Update(grid, i, j, n)
    if a:i < 0 || a:i >= a:n || a:j < 0 || a:j >= a:n
        return a:grid
    endif
    if a:grid[a:i][a:j] == -1
        return a:grid
    endif
    let grid = copy(a:grid)
    let grid[a:i][a:j] += 1
    if grid[a:i][a:j] > 9
        let grid = Flash(grid, a:i, a:j, a:n)
    endif
    return grid
endfunction

function! ComputeStep(grid, n)
    let grid = copy(a:grid)
    for i in range(a:n)
        for j in range(a:n)
            let grid = Update(grid, i, j, a:n)
        endfor
    endfor
    return grid
endfunction

function! ComputeSteps(grid, remaining, n)
    let nb_flash = 0
    for i in range(a:remaining)
        let grid = ComputeStep(a:grid, a:n)
        for i in range(a:n)
            for j in range(a:n)
                if grid[i][j] == -1
                    let grid[i][j] = 0
                    let nb_flash += 1
                endif
            endfor
        endfor
    endfor
    return nb_flash
endfunction

function! ComputeSyncStep(grid, n)
    let nstep = 0
    while 1
        let nstep += 1
        let grid = ComputeStep(a:grid, a:n)
        let isinsync = 1
        for i in range(a:n)
            for j in range(a:n)
                if grid[i][j] == -1
                    let grid[i][j] = 0
                else
                    let isinsync = 0
                endif
            endfor
        endfor
        if isinsync
            return nstep
        endif
    endwhile
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    let grid = Parse()
    return "Solution 1: " . ComputeSteps(grid, 100, 10)
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let grid = Parse()
    return "Solution 2: " . ComputeSyncStep(grid, 10)
endfunction
"}}}
