class Dagon::Ast::Generator
prechigh
  left EXPONENT
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

  class_definition: CONSTANT ':' block { result = [:class_definition, [:constant, val[0]], val[2]] }

  method_definition: identifier ':' block { result = [:method_definition, val[0], val[2]] }
                   | identifier LPAREN RPAREN ':' block { result = [:method_definition, val[0], val[4]] }

  assignment: identifier ASSIGNMENT expression { result = [:assignment, val[0], val[2]] }

  expression: expression '-' expression { result = [:subtraction, val[0], val[2]] }
            | expression '+' expression { result = [:addition, val[0], val[2]] }
            | expression '*' expression { result = [:multiplication, val[0], val[2]] }
            | expression '/' expression { result = [:division, val[0], val[2]] }
            | expression EXPONENT expression { result = [:exponentiation, val[0], val[2]] }
            | term

  array: LBRACKET contents RBRACKET { result = [:array, [:values, val[1]]] }
  contents: literal { result = val }
          | contents COMMA ' ' literal { result.push val[3] }

  term: identifier
      | literal
      | array
      | method_call
      | method_call_on_object

  literal: FLOAT { result = [:float, val[0].to_f] }
         | INTEGER { result = [:integer, val[0].to_i] }
         | DOUBLE_QUOTE identifier DOUBLE_QUOTE { result = [:string, val[1][1] ]}

  identifier: IDENTIFIER { result = [:identifier, val[0]]}

  method_call_on_object: identifier DOT method_call { result = [:call_on_object, val[0], val[2]]}
  method_call: identifier LPAREN RPAREN { result = [:call, val[0], [:args, []]] }
             | identifier LPAREN expression RPAREN { result = [:call, val[0], [:args, [val[2]]]] }
end

---- header
---- inner
  attr_accessor :table
  def initialize(tokens, debug = false)
    @yydebug = debug
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
  def next_token
    tokens.shift
  end

  private
  attr_accessor :tokens
