if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "lizzrmir"

syntax match comment "\v;.*$"
highlight link lizzrComment comment

"syntax region rest start="\%^"hs=s end='\%$'
syntax keyword litkw lit nextgroup=litval skipwhite
highlight link litkw Keyword
syn region litval start='\v.{-}\, 'hs=e+1 end='\v\w{-}$'rs=e-1 contained
highlight link litval Constant

syntax match str "\v\".{-}\"" containedin=litval
highlight link str String

syntax keyword kw var set ret add arg jif jifn gt lt eq ne neg j obj alloc ld st dealloc
highlight link kw Keyword

syntax keyword proc proc nextgroup=procnm skipwhite
highlight link proc Keyword
syntax match procnm "\v(\w|\.)+" contained
highlight link procnm Function

syntax keyword call call nextgroup=callhl skipwhite
highlight link call Keyword
syntax region callhl start=".\{-\}, "hs=e+1 end=" "he=s-1 contained
highlight link callhl Function
syntax region callhl start="\v(\i|\.)* "hs=s end=" "he=s-1 contained
highlight link callhl Function

syntax region perc start="\v( \%\w+)"hs=s+1 end="\v(.|$)"he=s-1 containedin=ALL
highlight link perc NormalFloat

syntax region tag start="\v(\`\w+)"hs=s end="\v(.|$)"he=s-1 containedin=ALL
highlight link tag PMenuThumb

syntax region typ start="\v\w:\i"hs=e end="\v(,)"he=s-1 containedin=ALL
highlight link typ Type

