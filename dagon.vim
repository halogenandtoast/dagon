" Vim syntax file
" Language: Dagon
" Maintainer: Caleb Thompson
" Latest Revision: 16 January 2013

au BufRead,BufNewFile *.dg set filetype=dagon

if exists("b:current_syntax")
    finish
endif

syntax keyword dagonConditional if elseif else while break
syntax keyword dagonBoolean true false
syntax keyword dagonKeyword void
syntax keyword dagonFunction print puts
syntax match dagonNumber '\d'
syntax match dagonFloat '\d+\.\d+'
syntax region String start="'" end="'"
syntax region String start='"' end='"'
syntax region Array start="\[" end="\]"
syntax match dagonComment "\v#.*$"
syntax match dagonConstant "\v[A-Z][A-Za-z]*"
syntax match dagonIdentifier "\v-?[a-z][a-z0-9-]+"
syntax match dagonFunctionDefinition "\v-?[a-z][a-z0-9-]+:"
syntax region dagonFunctionDefinitionArgumentList start="\v-?[a-z][a-z0-9-]+\(" end="):"
syntax region dagonFunctionCall start="\v-?[a-z][a-z0-9-]+\(" end=")"
syntax match dagonOperator "\v \*\* "
syntax match dagonOperator "\v \* "
syntax match dagonOperator "\v / "
syntax match dagonOperator "\v \+ "
syntax match dagonOperator "\v - "
syntax match dagonAssignment ": "

highlight link dagonConditional Conditional
highlight link dagonKeyword Keyword
highlight link dagonBoolean Boolean
highlight link dagonIdentifier dagonFunction
highlight link dagonFunctionDefinition dagonFunction
highlight link dagonFunction Function

highlight link dagonComment Comment
highlight link dagonOperator Operator
highlight link dagonConstant Constant

let b:current_syntax = "dagon"
