" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let g:input=[]
    normal! mm
    call execute('g/^.*$/normal! _"xyiwt "yyiw$"byiwT "ayiw:call add(g:input, [1 * @x,  1 * @y, 1 * @a, 1 * @b])' . "\r")
    normal! `m
    return g:input
endfunction
"}}}

" Utils {{{
function! GetSegments(input, diagonal)
    let points = {}

    for coor in a:input

        if coor[0] == coor[2]
            for i in range(min([coor[1], coor[3]]), max([coor[1], coor[3]]))
                let key = coor[0] . ', ' . i
                if has_key(points, key)
                    let points[key] += 1 
                else
                    let points[key] = 1
                endif
            endfor
        elseif coor[1] == coor[3]
            for i in range(min([coor[0], coor[2]]), max([coor[0], coor[2]]))
                let key = i . ', ' . coor[1]
                if has_key(points, key)
                    let points[key] += 1 
                else
                    let points[key] = 1
                endif
            endfor
        elseif  a:diagonal && (coor[0] - coor[2]) * (coor[0] - coor[2]) == (coor[1] - coor[3]) * (coor[1] - coor[3])
            let step_row = 2 * (coor[2] > coor[0]) - 1
            let step_col = 2 * (coor[3] > coor[1]) - 1
            for i in range(max([coor[0], coor[2]]) - min([coor[0], coor[2]]) + 1)
                let row = coor[0] + i * step_row
                let col = coor[1] + i * step_col
                let key = row . ', ' . col
                if has_key(points, key)
                    let points[key] += 1 
                else
                    let points[key] = 1
                endif
            endfor
        endif

    endfor

    return points
endfunction

function! GetAtLeastTwoLines(points)
    let nb_point = 0
    for value in values(a:points)
        if value >= 2
            let nb_point += 1
        endif
    endfor
    return nb_point
endfunction


"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    return "Solution 1: " . GetAtLeastTwoLines(GetSegments(input, 0))
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    " echom GetSegments(input, 1)
    return "Solution 2: " . GetAtLeastTwoLines(GetSegments(input, 1))
endfunction
"}}}
