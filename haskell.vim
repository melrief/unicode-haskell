" Unicode Haskell for Vim
" Based on Haskell Cuteness by Andrey Popp <andrey.popp@braintrace.ru>

let s:mappedChars = {
  \ '\': 'λ',
  \ '<-': '←',
  \ '->': '→',
  \ '<=': '≲',
  \ '>=': '≳',
  \ '==': '≡',
  \ '/=': '≠',
  \ '=>': '⇒',
  \ '>>': '»',
  \ '. ': '∙ ',
  \ 'forall ': '∀'
  \ }

" Turn entered text into Unicode characters if possible
for [key, value] in items(s:mappedChars)
    exec "imap <buffer>" key value
endfor

" Turn syntax highlight on for new symbols
syn match hsVarSym "(\|λ\|←\|→\|≲\|≳\|≡\|≠\| )"

if exists("s:loaded_unihaskell")
    finish
endif
let s:loaded_unihaskell = 1

augroup HaskellC
    autocmd BufReadPost *.hs cal s:HaskellSrcToUTF8()
    autocmd BufWritePre *.hs cal s:UTF8ToHaskellSrc()
    autocmd BufWritePost *.hs cal s:HaskellSrcToUTF8()
augroup END

function s:safeRegexp(s)
    return escape(a:s, "\\.")
endfunction

" Convert Unicode Haskell source code to plain ASCII source code when saving
" data.
function s:UTF8ToHaskellSrc()
    let s:line = line(".")
    let s:column = col(".")

    for [key, value] in items(s:mappedChars)
        exec "%s," . value . "," . s:safeRegexp(key) . ",eg"
    endfor

    let &l:fileencoding = s:oldencoding
    call cursor(s:line,s:column)
endfunction

" Convert ASCII Haskell source code to fancy Unicode source code when reading
" Haskell programs.
function s:HaskellSrcToUTF8()
    let s:line = line(".")
    let s:column = col(".")

    let s:oldencoding = &l:fileencoding
    set fileencoding=utf-8

    for [key, value] in items(s:mappedChars)
        exec "%s," . s:safeRegexp(key) . "," . value . ",eg"
    endfor

    let &l:fileencoding = s:oldencoding
    call cursor(s:line,s:column)
endfunction

do HaskellC BufRead
