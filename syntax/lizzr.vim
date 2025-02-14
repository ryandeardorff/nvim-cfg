if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "lizzr"

"syntax match lizzrComment "\v##\_.{-}##"
syntax match lizzrComment "\v(#)@<!#[^#].*$"
highlight link lizzrComment Comment

syntax keyword lizzrKw fn inter impl enum union op comp
syntax keyword lizzrKw ret break cont in
syntax keyword lizzrKw throw catch
syntax keyword lizzrKw pub priv
highlight link lizzrKw Keyword

syntax keyword lizzrCond if else
highlight link lizzrCond Conditional

syntax keyword lizzrRep lp
highlight link lizzrRep Repeat

syntax keyword lizzrTyp f32 f64 i32 i64 u8 u16 u32 u64
syntax keyword lizzrTyp bool
syntax keyword lizzrTyp str
highlight link lizzrTyp Type

syntax match lizzrFloat "\v\d+(\.)\d@=\d+(d|)"
highlight link lizzrFloat Float

syntax match lizzrNum "\v(\l|\d|\.)@<!\d+(\.)@!"
highlight link lizzrNum Number

syntax keyword lizzrBool true false
highlight link lizzrBool Boolean

syntax match lizzrConst "\v\d+\.\.\d+"
highlight link lizzrConst Constant

syntax match lizzrStr "\v\"(\\.|[^\\\"]){-}\""
highlight link lizzrStr String

syntax match lizzrChar "\v\'.\'"
highlight link lizzrChar Character

syntax match lizzrStruct "\v\w+\s*(\{|(impl))@="
" Known usages
syntax match lizzrStruct "\v(:\s*)@<=(\l|\u|_)\w*"
syntax match lizzrStruct "\v(\u|\l|_)\w*\ze\."
highlight link lizzrStruct Structure

syntax match lizzrFunc "\v((fn)\s*)@<=\w*"
"syntax match lizzrFunc "\v((inter)\s*)@<=\w*"
" Known usages
"syntax match lizzrFunc "\v((impl)\s*)@<=\w*"
syntax match lizzrFunc "\v(\u|\l|_)\w+\ze\s*\("
highlight link lizzrFunc Function

syntax keyword lizzrSpecial nil
highlight link lizzrSpecial Special

syntax match lizzrOp  "\v\="
syntax match lizzrOp  "\v\+"
syntax match lizzrOp  "\v\/"
syntax match lizzrOp  "\v\-"
syntax match lizzrOp  "\v\^"
syntax match lizzrOp  "\v\*"
syntax match lizzrOp  "\v\!"
syntax match lizzrOp  "\v\?"
syntax match lizzrOp  "\v\&"
syntax match lizzrOp  "\v\-\>"
highlight link lizzrOp Operator
