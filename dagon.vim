" Vim syntax file
" Language: Dagon
" Maintainer: Caleb Thompson
" Latest Revision: 16 January 2013

if exists("b:current_syntax")
  finish
endif

syn keyword Statement if elseif else
syn keyword Boolean true false
syn match Constant '[A-Z][A-Za-z]*'
syn match Number '\d'
syn match Float '\d+\.\d+'
syn region String start="'" end="'"
syn region String start='"' end='"'
syn match Operator ' [+-/*\(**\)] '
syn match Operator ':'
syn match Comment "^#.*$"
