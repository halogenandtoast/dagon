class Ast::Generator
rule
  target: program { result = [:program, val[0]]}

  program: { result = [] }
         | statements

  block: INDENT statements NEWLINE DEDENT { result = [:block, val[1]] }
       | INDENT statements { result = [:block, val[1]] }

  statements: statements statement { result = [*val[0], val[1]] }
            | statement { result = [val[0]] }

  statement: method_definition
           | assignment
           | expression
           | NEWLINE { result = [:noop, :noop] }

  method_definition: identifier ':' NEWLINE block { result = [:method_definition, val[0], val[3]] }
                   | identifier LPAREN RPAREN ':' NEWLINE block { result = [:method_definition, val[0], val[5]] }

  assignment: identifier ':' ' ' expression { result = [:assignment, val[0], val[3]] }

  expression: term ' ' '*' ' ' expression { result = [:addition, val[0], val[4]] }
            | term ' ' '/' ' ' expression { result = [:division, val[0], val[4]] }
            | term ' ' '-' ' ' expression { result = [:subtraction, val[0], val[4]] }
            | term ' ' '+' ' ' expression { result = [:addition, val[0], val[4]] }
            | term ' ' '**' ' ' expression { result = [:exponentiation, val[0], val[4]] }
            | term

  term: identifier
      | literal
      | method_call

  literal: FLOAT { result = [:float, val[0].to_f] }
         | INTEGER { result = [:integer, val[0].to_i] }

  identifier: IDENTIFIER { result = [:identifier, val[0]]}

  method_call: identifier LPAREN RPAREN { result = [:call, val[0], [:args, []]] }
             | identifier LPAREN expression RPAREN { result = [:call, val[0], [:args, [val[2]]]] }
end

---- header
---- inner
  attr_accessor :table
  def initialize(tokens)
    @yydebug = true
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
