class Dagon::Ast::Generator
prechigh
  right EXPONENT
  left '*' '/'
  left '+' '-'
  left ':'
  nonassoc '>' '<' '>=' '<=' '=' '!='
preclow
rule
  target: program { result = [:program, val[0]]}

  program: { result = [] }
         | statements

  block: INDENT statements DEDENT { result = [:block, val[1]] }

  statements: statements statement { result.push val[1] }
            | statement { result = [val[0]] }

  statement: class_definition
           | method_definition
           | assignment
           | expression
           | conditional_statement
           | while_statement

  while_statement: WHILE condition block { result = [:while_statement, val[1], val[2]] }

  conditional_statement: IF condition block { result = [:conditional_statement, [[:if, val[1], val[2]]]] }
                       | conditional_statement ELSEIF condition block { result[1] << [:elseif, val[2], val[3]] }
                       | conditional_statement ELSE block { result[1] << [:else, [:true, true], val[2]] }

  class_definition: CONSTANT ':' block { result = [:class_definition, [:constant, val[0]], val[2]] }

  method_definition: identifier ':' block { result = [:method_definition, val[0], [:args, []], val[2]] }
                   | identifier LPAREN list RPAREN ':' block { result = [:method_definition, val[0], [:args, *val[2]], val[5]]}

  assignment: identifier ASSIGNMENT expression { result = [:assignment, val[0], val[2]] }

  expression: expression '-' expression { result = call_on_object(val[0], val[1], val[2]) }
            | expression '+' expression { result = call_on_object(val[0], val[1], val[2]) }
            | expression '*' expression { result = call_on_object(val[0], val[1], val[2]) }
            | expression '/' expression { result = call_on_object(val[0], val[1], val[2]) }
            | expression EXPONENT expression { result = call_on_object(val[0], '**', val[2]) }
            | condition

  condition: expression '>' expression { result = call_on_object(val[0], val[1], val[2]) }
           | expression '<' expression { result = call_on_object(val[0], val[1], val[2]) }
           | expression '<=' expression { result = call_on_object(val[0], val[1], val[2]) }
           | expression '>=' expression { result = call_on_object(val[0], val[1], val[2]) }
           | expression '=' expression { result = call_on_object(val[0], :equal, val[2]) }
           | expression '!=' expression { result = call_on_object(val[0], :not_equal, val[2]) }
           | term

  array: LBRACKET list RBRACKET { result = [:array, [:values, val[1]]] }
  list: { result = [] }
      | expression { result = val }
      | list COMMA expression { result.push val[2] }

  term: identifier
      | literal
      | array
      | method_call
      | method_call_on_object

  literal: FLOAT { result = [:float, val[0].to_f] }
         | INTEGER { result = [:integer, val[0].to_i] }
         | STRING { result = [:string, val[0]] }
         | TRUE { result = [:true, true] }
         | FALSE { result = [:false, false] }

  identifier: IDENTIFIER { result = [:identifier, val[0]]}

  method_call_on_object: identifier DOT method_call { result = [:call_on_object, val[0], val[2]] }
  method_call: identifier LPAREN list RPAREN { result = [:call, val[0], [:args, val[2]]] }
end

---- header
---- inner
  attr_accessor :table
  def initialize(tokens, debug = false)
    @yydebug = debug
    @tokens = tokens
    @line = 0
  end

  def parse
    @table = do_parse
    self
  end

  private
  attr_accessor :tokens
  def next_token
    token = tokens.shift
    if token
      info = token.pop
      @line = info[0]
    end
    token
  end

  def on_error error_token_id, error_value, value_stack
    $stderr.puts "line #{@line+1}: syntax error, unexpected #{error_value}", value_stack.inspect
    exit
  end

  def call_on_object(object, method, *args)
    [:call_on_object, object, [:call, [:identifier, method], [:args, args]]]
  end
