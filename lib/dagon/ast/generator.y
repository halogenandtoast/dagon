class Dagon::Ast::Generator
prechigh
  left '*' '/'
  left '+' '-'
preclow
rule
  target: program EOF { result = [:program, val[0]]}

  program: { result = [] }
         | statements

  block: INDENT statements DEDENT { result = [:block, val[1]] }

  statements: statements statement { result = [*val[0], val[1]] }
            | statement { result = [val[0]] }

  statement: class_definition
           | method_definition
           | assignment
           | expression
           | NEWLINE { result = [:noop, :noop] }

  class_definition: CONSTANT ':' block { result = [:class_definition, [:constant, val[0]], val[2]] }

  method_definition: identifier ':' block { result = [:method_definition, val[0], val[2]] }
                   | identifier LPAREN RPAREN ':' block { result = [:method_definition, val[0], val[4]] }

  assignment: identifier ':' ' ' expression { result = [:assignment, val[0], val[3]] }

  expression: term ' ' '*' ' ' expression { result = [:multiplication, val[0], val[4]] }
            | term ' ' '/' ' ' expression { result = [:division, val[0], val[4]] }
            | term ' ' '-' ' ' expression { result = [:subtraction, val[0], val[4]] }
            | term ' ' '+' ' ' expression { result = [:addition, val[0], val[4]] }
            | term ' ' '**' ' ' expression { result = [:exponentiation, val[0], val[4]] }
            | term

  term: identifier
      | literal
      | method_call
      | method_call_on_object

  literal: FLOAT { result = [:float, val[0].to_f] }
         | INTEGER { result = [:integer, val[0].to_i] }

  identifier: IDENTIFIER { result = [:identifier, val[0]]}

  method_call_on_object: identifier '.' method_call { result = [:call_on_object, val[0], val[2]]}
  method_call: identifier LPAREN RPAREN { result = [:call, val[0], [:args, []]] }
             | identifier LPAREN expression RPAREN { result = [:call, val[0], [:args, [val[2]]]] }
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
