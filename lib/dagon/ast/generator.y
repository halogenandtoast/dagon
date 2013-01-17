class Ast::Generator
rule
  target: program { result = [:program, val[0]]}

  program: statement | program NEWLINE statement

  statement: expression | assignment | method_call

  method_call: identifier OPEN_PAREN expressable CLOSE_PAREN { result = [:call, val[0], val[2]] }

  assignment: identifier ':' ' ' literal    { result = [:assignment, val[0], val[3]] }
            | identifier ':' ' ' identifier { result = [:assignment, val[0], val[3]] }

  expression: expressable logical expressable { result = [val[1], val[0], val[2]] }

  expressable: expression | identifier | literal | method_call

  logical: ' ' '+' ' '  { result = :addition }
         | ' ' '-' ' '  { result = :subtraction }
         | ' ' '*' ' '  { result = :multiplication }
         | ' ' '/' ' '  { result = :division }
         | ' ' '**' ' ' { result = :exponentiation }

  literal: FLOAT { result = [:float, val[0].to_f] }
         | INTEGER { result = [:integer, val[0].to_i] }

  identifier: IDENTIFIER { result = [:identifier, val[0]]}
end

---- header
---- inner
  attr_accessor :table
  def initialize(tokens)
    @tokens = tokens
  end

  def parse
    @table = do_parse
    self
  end

  def next_token
    tokens.shift
  end

  private
  attr_accessor :tokens
