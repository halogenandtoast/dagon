class Dagon::Parser
prechigh
  right EXPONENT
  left '*' '/'
  left '+' '-'
  left ':'
  nonassoc '>' '<' '>=' '<=' '=' '!='
preclow
rule
  program: { result = [] }
         | statements { result = AST::RootNode.new(val[0]) }

  block: INDENT statements DEDENT { result = val[1] }

  inline_block: LBRACE statement RBRACE { result = [val[1]] }

  statements: statements statement { result.push val[1] }
            | statement { result = [val[0]] }

  statement: class_definition
           | method_definition
           | assignment
           | expression
           | conditional_statement
           | while_statement
           | method_call_with_block

  while_statement: WHILE condition block { result = AST::WhileNode.new(@filename, nil, val[1], val[2]) }

  conditional_statement: IF condition block else_stmt { result = AST::IfNode.new(@filename, nil, val[1], val[2], val[3]) }
  else_stmt: { result = nil }
           | ELSEIF condition block else_stmt{ result = [AST::IfNode.new(@filename, nil, val[1], val[2], val[3])] }
           | ELSE block { result = val[1] }

  class_definition: CONSTANT ':' block { result = AST::ClassDefinitionNode.new(@filename, nil, val[0].data, val[2]) }

  method_definition: IDENTIFIER ':' block { result = AST::FunctionDefinitionNode.new(@filename, nil, val[0].data, AST::Function.new(@filename, nil, [], val[2])) }
                   | IDENTIFIER ASSIGNMENT inline_block { result = AST::FunctionDefinitionNode.new(@filename, nil, val[0].data, AST::Function.new(@filename, nil, [], val[2])) }
                   | IDENTIFIER LPAREN list RPAREN ':' block { result = AST::FunctionDefinitionNode.new(@filename, nil, val[0].data, AST::Function.new(@filename, nil, val[2], val[5])) }
                   | IDENTIFIER LPAREN list RPAREN ASSIGNMENT inline_block { result = AST::FunctionDefinitionNode.new(@filename, nil, val[0].data, AST::Function.new(@filename, nil, val[2], val[5])) }

  assignment: IDENTIFIER ASSIGNMENT expression { result = AST::AssignmentNode.new(@filename, nil, val[0].data, val[2]) }

  expression: expression '-' expression { result = call_on_object(val[0], '-', val[2]) }
            | expression '+' expression { result = call_on_object(val[0], '+', val[2]) }
            | expression '*' expression { result = call_on_object(val[0], '*', val[2]) }
            | expression '/' expression { result = call_on_object(val[0], '/', val[2]) }
            | expression EXPONENT expression { result = call_on_object(val[0], '**', val[2]) }
            | condition

  condition: expression '>' expression { result = call_on_object(val[0], '>', val[2]) }
           | expression '<' expression { result = call_on_object(val[0], '<', val[2]) }
           | expression '<=' expression { result = call_on_object(val[0], '<=', val[2]) }
           | expression '>=' expression { result = call_on_object(val[0], '>=', val[2]) }
           | expression '=' expression { result = call_on_object(val[0], '=', val[2]) }
           | expression '!=' expression { result = call_on_object(val[0], '!=', val[2]) }
           | term

  array: LBRACKET list RBRACKET { result = AST::ArrayNode.new(@filename, nil, val[1]) }
  list: { result = [] }
      | list_member { result = val }
      | list COMMA list_member { result.push val[2] }
  list_member: expression { result = val[0] }
             | assignment { result = val[0] }


  term: IDENTIFIER { result = AST::VarRefNode.new(@filename, nil, val[0].data) }
      | literal
      | array
      | method_call
      | object_call

  literal: FLOAT { result = AST::LiteralNode.new(@filename, nil, val[0].data.to_f) }
         | INTEGER { result = AST::LiteralNode.new(@filename, nil, val[0].data.to_i) }
         | STRING { result = AST::StringNode.new(@filename, nil, val[0].data) }
         | TRUE { result = AST::LiteralNode.new(@filename, nil, true) }
         | FALSE { result = AST::LiteralNode.new(@filename, nil, false) }
         | VOID { result = AST::LiteralNode.new(@filename, nil, nil) }

  method_call: IDENTIFIER DOT IDENTIFIER optional_block { result = AST::FunctionCallNode.new(@filename, nil, AST::VarRefNode.new(@filename, nil, val[0].data), val[2].data, [], val[3]) }
             | IDENTIFIER DOT IDENTIFIER LPAREN list RPAREN optional_block { result = AST::FunctionCallNode.new(@filename, nil, AST::VarRefNode.new(@filename, nil, val[0].data), val[2].data, val[4], val[6]) }
             | IDENTIFIER LPAREN list RPAREN optional_block { result = AST::FunctionCallNode.new(@filename, nil, nil, val[0].data, val[2], val[4]) }
             | IDENTIFIER '[' expression RBRACKET { result = AST::FunctionCallNode.new(@filename, nil, AST::VarRefNode.new(@filename, nil, val[0].data), '[]', [val[2]], nil) }

  object_call: CONSTANT LPAREN list RPAREN optional_block { result = AST::InstanceInitNode.new(@filename, nil, val[0].data, val[2], val[4]) }

  optional_block: { result = nil }
                | ARROW block { result = AST::BlockNode.new(@filename, nil, val[1]) }

---- header
NODES = %w(node root_node function_call_node function_definition_node function_node string_node literal_node var_ref_node if_node assignment_node while_node class_definition_node instance_init_node block_node array_node)
NODES.each { |node| require_relative "../dagon/ast/#{node}" }

---- inner

  def initialize(tokens, filename, debug = false)
    @yydebug = debug
    @filename = filename
    @tokens = tokens
    @line = 0
  end

  def parse
    do_parse
  end

  def self.parse(tokens, filename, debug = false)
    new(tokens, filename, debug).parse
  end

  private
  attr_accessor :tokens
  def next_token
    tokens.shift
  end

  def on_error error_token_id, error_value, value_stack
    $stderr.puts "line #{@filename}:#{@line+1}: syntax error, unexpected #{error_value.data.inspect}", value_stack.inspect
    exit
  end

  def call_on_object(object, method, *args)
    AST::FunctionCallNode.new(@filename, nil, object, method, args, nil)
  end
