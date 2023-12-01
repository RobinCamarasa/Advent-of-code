" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
set maxfuncdepth=500
"}}}

" Parse Input {{{
function! Parse()
    let grid=[]
    normal! mm
    call execute('g/^.*$/normal! _"ly$:call add(grid, map(split(@l, ''\zs''), {id, val -> 1 * val}))' . "\r")
    normal! `m
    return grid
endfunction
"}}}

" Utils {{{
function! InitializeCost(grid, n, m)
    let cost = []
    for i in range(a:n)
        let cost_row = []
        for j in range(a:m)
            call add(cost_row, 0)
        endfor
        call add(cost, cost_row)
    endfor
    return cost
endfunction

function! GenerateCostGrid(cost, grid, n, m)
    let cost = copy(a:cost)
    let cost[0][0] = 0
    for i in range(1, a:n-1)
        let cost[i][0] = cost[i-1][0] + a:grid[i][0]
    endfor
    for j in range(1, a:m-1)
        let cost[0][j] = cost[0][j-1] + a:grid[0][j]
    endfor
    for i in range(1, a:n-1)
        for j in range(1, a:m-1)
            let cost[i][j] = min([cost[i-1][j], cost[i][j-1]]) + a:grid[i][j]
        endfor
    endfor
    return cost
endfunction

function! GenerateSecondGrid(grid, n, m)
    let bigger_grid = []
    for i in range(5 * a:n)
        let bigger_row = []
        for j in range(5 * a:m)
            call add(bigger_row, (a:grid[i%a:n][j%a:m] + (i/a:n + j/a:m - 1)) % 9 + 1)
        endfor
        call add(bigger_grid, bigger_row)
    endfor
    return bigger_grid
endfunction

function! GetNeighbours(i, j, n, m)
    let neighbours = []
    for delta in [-1, 1]
        if a:i + delta>= 0 && a:i + delta < a:n
            call add(neighbours, [a:i + delta, a:j])
        endif
        if a:j + delta>= 0 && a:j + delta < a:n
            call add(neighbours, [a:i, a:j + delta])
        endif
    endfor
    return neighbours
endfunction

function! GetCost(grid, candidates, visited, n, m)
    " Check final case
    if a:visited[len(a:visited) - 1][0] == (a:n - 1) . ',' . (a:m - 1)
        return a:visited[a:n - 1][1]
    endif

    " Check candidates
    let candidates = copy(a:candidates)
    let visited_coordinates = map(split(a:visited[len(a:visited) - 1][0], ','), {id, value -> 1 * value})
    let visited_cost = a:visited[len(a:visited) - 1][1]
    let neighbours = GetNeighbours(visited_coordinates[0], visited_coordinates[1], a:n, a:m)
    for candidate in neighbours
        let key = candidate[0] . ',' . candidate[1]
        let cost = visited_cost + a:grid[candidate[0]][candidate[1]]
        if index(map(a:visited, {id, value -> value}), key) == -1
            if has_key(candidates, key)
                let candidates[key] = min([cost, candidates[key]])
            else
                let candidates[key] = cost
            endif
        endif
    endfor
    unlet candidates[a:visited[-1][0]]

    " Compute the cost
    let min_cost = 10000000000
    let coordinate = ''
    for key in keys(candidates)
        if candidates[key] < min_cost
            let min_cost = candidates[key]
            let coordinate = key
        endif
    endfor
    let visited = copy(a:visited)
    call add(visited, [coordinate, min_cost])
    echom visited
    return GetCost(a:grid, candidates, visited, a:n, a:m)
endfunction

function! PrintGrid(grid)
    for row in a:grid
        echom join(row, "\t")
    endfor
endfunction

"}}}

" Part One {{{
function! SolvePartOne()
    let grid = Parse()
    let n = len(grid)
    let m = len(grid[0])
    let cost = InitializeCost(grid, n, m)
    let cost = GenerateCostGrid(cost, grid, n, m)
    return "Solution 1: " . cost[n-1][m-1]
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let grid = Parse()
    let n = len(grid)
    let m = len(grid[0])
    let bigger_grid = GenerateSecondGrid(grid, n, m)
    call GetCost(grid, {'0,0': 0}, [['0,0', 0]], n - 1, m - 1)
    " call PrintGrid(bigger_grid)
    " return "Solution 2: " . cost[5 * n - 1][5 * m - 1]
endfunction
"}}}
