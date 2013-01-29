class Dagon::Ast::Generator
prechigh
  right EXPONENT
  left '*' '/'
  left '+' '-'
  left ':'
  nonassoc '>' '<' '>=' '<=' '=' '!='
preclow
rule
  program: { result = [] }
         | statements { result = RootNode.new(val[0]) }

  block: INDENT statements DEDENT { result = val[1] }

  inline_block: LBRACE statement RBRACE { result = val[1] }

  statements: statements statement { result.push val[1] }
            | statement { result = [val[0]] }

  statement: class_definition
           | method_definition
           | assignment
           | expression
           | conditional_statement
           | while_statement
           | method_call_with_block

  while_statement: WHILE condition block { result = [:while_statement, val[1], val[2]] }

  conditional_statement: IF condition block else_stmt { result = IfNode.new(nil, nil, val[1], val[2], val[3]) }
  else_stmt: { result = nil }
           | ELSEIF condition block else_stmt{ result = IfNode.new(nil, nil, val[1], val[2], val[3]) }
           | ELSE block { result = val[1] }

  class_definition: CONSTANT ':' block { result = [:class_definition, [:constant, val[0]], val[2]] }

  method_definition: IDENTIFIER ':' block { result = FunctionDefinitionNode.new(nil, nil, val[0], Function.new(nil, nil, [], val[2])) }
                   | IDENTIFIER ASSIGNMENT inline_block { result = FunctionDefinitionNode.new(nil, nil, val[0], Function.new(nil, nil, [], val[2])) }
                   | IDENTIFIER LPAREN list RPAREN ':' block { result = FunctionDefinitionNode.new(nil, nil, val[0], Function.new(nil, nil, val[2], val[5])) }
                   | IDENTIFIER LPAREN list RPAREN ASSIGNMENT inline_block { result = FunctionDefinitionNode.new(nil, nil, val[0], Function.new(nil, nil, val[2], val[5])) }

  assignment: IDENTIFIER ASSIGNMENT expression { result = AssignmentNode.new(nil, nil, val[0], val[2]) }

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
           | expression '=' expression { result = call_on_object(val[0], '==', val[2]) }
           | expression '!=' expression { result = call_on_object(val[0], :not_equal, val[2]) }
           | term

  array: LBRACKET list RBRACKET { result = [:array, [:values, val[1]]] }
  list: { result = [] }
      | list_member { result = val }
      | list COMMA list_member { result.push val[2] }
  list_member: expression { result = val[0] }
             | assignment { result = val[0] }


  term: IDENTIFIER { result = VarRefNode.new(nil, nil, val[0]) }
      | literal
      | array
      | method_call
      | object_call
      | method_call_on_object

  literal: FLOAT { result = [:float, val[0].to_f] }
         | INTEGER { result = LiteralNode.new(nil, nil, val[0].to_i) }
         | STRING { result = StringNode.new(nil, nil, val[0]) }
         | TRUE { result = LiteralNode.new(nil, nil, true) }
         | FALSE { result = LiteralNode.new(nil, nil, false) }
         | VOID { result = LiteralNode.new(nil, nil, nil) }

  method_call_on_object: IDENTIFIER DOT method_call { result = [:call_on_object, val[0], *(val[2][1..-1])] }
                       | IDENTIFIER DOT method_call_with_block { result = [:call_on_object, val[0], *(val[2][1..-1])] }
  method_call: IDENTIFIER LPAREN list RPAREN { result = FunctionCallNode.new(nil, nil, val[0], val[2]) }
  method_call_with_block: IDENTIFIER ARROW block { result = [:call, val[0], [:args, []], val[2]] }
  object_call: CONSTANT LPAREN list RPAREN { result = [:object_call, val[0], [:args, val[2]]] }

---- header
NODES = %w(root_node core frame function_call_node function_definition_node function_node string_node kernel literal_node var_ref_node if_node)
NODES.each { |node| require_relative "../../lib/dagon/ast/#{node}" }

---- inner

  def initialize(tokens, debug = false)
    @yydebug = debug
    @tokens = tokens
    @line = 0
  end

  def parse
    do_parse
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
    $stderr.puts "line #{@line+1}: syntax error, unexpected #{error_value.inspect}", value_stack.inspect
    exit
  end

  def call_on_object(object, method, *args)
    FunctionCallNode.new(nil, nil, method, [object] + args)
  end
