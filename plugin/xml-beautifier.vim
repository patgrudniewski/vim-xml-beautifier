" XML beautifier
function! DoXmlBeautify() range
    let l:origft = &ft
    set ft=
    exe ":let l:beforeFirstLine=" . a:firstline . "-1"
    if l:beforeFirstLine < 0
        let l:beforeFirstLine = 0
    endif

    exe a:lastline . "put = '</beautifier_ROOT>'"
    exe l:beforeFirstLine . "put = '<beautifier_ROOT>'"

    exe ":let l:newLastLine = " . a:lastline . "+2"
    if l:newLastLine > line('$')
        let l:newLastLine = line('$')
    endif

    exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s//e"
    let l:newLastLine = search('</beautifier_ROOT>')

    set fileencoding=utf8
    exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"
    let l:newFirstLine = search('<beautifier_ROOT>')
    let l:newLastLine = search('</beautifier_ROOT>')

    let l:innerFirstLine = l:newFirstLine + 1
    let l:innerLastLine = l:newLastLine - 1

    exe ":silent " . l:innerFirstLine . "," . l:innerLastLine . "s/^  //e"

    exe l:newLastLine . "d"
    exe l:newFirstLine . "d"

    exe ":" . l:newFirstLine
    exe "set ft=" . l:origft
endfunction
command -range=% XMLBeautify <line1>,<line2>call DoXmlBeautify()
