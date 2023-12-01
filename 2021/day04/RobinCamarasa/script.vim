" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    normal! mm
    call execute('g/,/normal! _"ly$:let g:numbers=split(@l, ",")' . "\r")
    let g:grids = []
    call execute('g/^[0-9]*\s/normal! _"ly$:call add(g:grids, split(@l, ""))' . "\r")
    let g:truth_grids = []
    for i in range(len(g:grids))
        let truth_row = []
        for j in range(len(g:grids[0]))
            call add(truth_row, 0)
        endfor
        call add(g:truth_grids, truth_row)
    endfor
    normal! `m
    return {"numbers": g:numbers, 
            \"grids": g:grids, 
            \"truth_grids": g:truth_grids, 
            \"grid_size": len(g:grids[0])}
endfunction
"}}}

" Utils {{{
function! UpdateGrid(grids, truth_grids, number)
    let g:truth_grids = copy(a:truth_grids)
    for i in range(len(a:grids))
        for j in range(len(a:grids[0]))
            if a:grids[i][j] - a:number ==# 0
                let g:truth_grids[i][j] = 1
            endif
        endfor
    endfor
    return g:truth_grids
endfunction

function! CheckGrids(grids, truth_grids, grid_size, number, detected_grids)
    let g:detected_grids = copy(a:detected_grids)
    for g:i in range(0, len(a:truth_grids)-1, a:grid_size)
        if index(a:detected_grids, g:i) ==# -1
            for j in range(a:grid_size)
                let g:isrow=1
                let g:iscolumn=1
                for k in range(a:grid_size)
                    if 1 - a:truth_grids[g:i + k][j] * g:isrow
                        let g:isrow = 0
                    endif
                    if 1 - a:truth_grids[g:i + j][k] * g:iscolumn
                        let g:iscolumn = 0
                    endif
                endfor
                if g:isrow + g:iscolumn && (index(g:detected_grids, g:i) ==# -1)
                    call add(g:detected_grids, g:i)
                endif
            endfor
        endif
    endfor
    return g:detected_grids
endfunction

function! SumGrid(grids, truth_grids, winning_board, grid_size)
    let g:sum = 0
    for i in range(a:winning_board, a:winning_board + a:grid_size - 1)
        for j in range(len(a:grids[0]))
            let g:sum += a:grids[i][j] * (1 - a:truth_grids[i][j])
        endfor
    endfor
    return g:sum
endfunction

"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    for i in range(len(input['numbers']))
        let input['truth_grids'] = UpdateGrid(
            \input['grids'],
            \input['truth_grids'],
            \input['numbers'][i]
            \)
        let g:detected_grids = CheckGrids(
            \input['grids'],
            \input['truth_grids'],
            \input['grid_size'],
            \input['numbers'][i],
            \[]
            \)
        if len(g:detected_grids)
            return "Solution 1: " .
                \input['numbers'][i] * 
                \SumGrid(
                    \input['grids'],
                    \input['truth_grids'],
                    \g:detected_grids[-1],
                    \input['grid_size'],
                    \)
        endif
    endfor
    return "Solution 1: Not solved"
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    let g:detected_grids = []
    for i in range(len(input['numbers']))
        let input['truth_grids'] = UpdateGrid(
            \input['grids'],
            \input['truth_grids'],
            \input['numbers'][i]
            \)
        let g:detected_grids = CheckGrids(
            \input['grids'],
            \input['truth_grids'],
            \input['grid_size'],
            \input['numbers'][i],
            \g:detected_grids
            \)
        if len(g:detected_grids) * input['grid_size'] ># len(input['grids'])
            echom g:detected_grids
        endif
        if len(g:detected_grids) * input['grid_size'] ==# len(input['grids'])
            return "Solution 2: " .
                \input['numbers'][i] * 
                \SumGrid(
                    \input['grids'],
                    \input['truth_grids'],
                    \g:detected_grids[-1],
                    \input['grid_size'],
                    \)
        endif
    endfor
    return "Solution 2: Not solved"
endfunction

"}}}
