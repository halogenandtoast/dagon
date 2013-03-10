class Dagon::Parser
prechigh
  right EXPONENT
  left '!'
  left '&&' '||' '^'
  left '*' '/'
  left '+' '-'
  left ':'
  nonassoc '>' '<' '>=' '<=' '=' '!='
preclow
rule
  program: { result = AST::RootNode.new([]) }
         | statements { result = AST::RootNode.new(val[0]) }

  block: INDENT statements DEDENT { result = val[1] }

  statements: statements statement { result.push val[1] }
            | statement { result = [val[0]] }

  statement: class_definition
           | method_definition
           | assignment
           | expression
           | conditional_statement
           | while_statement
           | begin_block

  begin_block: BEGIN multiline_lambda rescue_block { result = AST::BeginBlockNode.new(@filename, nil, val[1], val[2]) }

  rescue_block: {}
              | RESCUE LPAREN list RPAREN multiline_lambda { result = AST::RescueBlockNode.new(@filename, nil, val[4], val[2]) }
              | RESCUE multiline_lambda { result = AST::RescueBlockNode.new(@filename, nil, val[1], nil) }

  while_statement: WHILE condition block { result = AST::WhileNode.new(@filename, nil, val[1], val[2]) }

  conditional_statement: IF condition block else_stmt { result = AST::IfNode.new(@filename, nil, val[1], val[2], val[3]) }
  else_stmt: { result = nil }
           | ELSEIF condition block else_stmt{ result = [AST::IfNode.new(@filename, nil, val[1], val[2], val[3])] }
           | ELSE block { result = val[1] }

  class_definition: CONSTANT ':' block { result = AST::ClassDefinitionNode.new(@filename, nil, val[0].data, val[2]) }


  assignment: method_name ASSIGNMENT expression { result = AST::AssignmentNode.new(@filename, nil, val[0].variable_name, val[2]) }
            | method_name ASSIGNMENT multiline_lambda { result = AST::AssignmentNode.new(@filename, nil, val[0].variable_name, val[2]) }
            | '@' method_name ASSIGNMENT expression { result = AST::AssignmentNode.new(@filename, nil, "@#{val[1].variable_name}", val[3]) }

  expression: expression '-' expression { result = call_on_object(val[0], '-', val[2]) }
            | expression '+' expression { result = call_on_object(val[0], '+', val[2]) }
            | expression '*' expression { result = call_on_object(val[0], '*', val[2]) }
            | expression '/' expression { result = call_on_object(val[0], '/', val[2]) }
            | expression '&&' expression { result = call_on_object(val[0], '&&', val[2]) }
            | expression '||' expression { result = call_on_object(val[0], '||', val[2]) }
            | expression '^' expression { result = call_on_object(val[0], '^', val[2]) }
            | expression EXPONENT expression { result = call_on_object(val[0], '**', val[2]) }
            | condition

  unary_expression: '!' expression { result = AST::UnaryFunctionCallNode.new(@filename, nil, val[1], "!") }

  condition: expression '>' expression { result = call_on_object(val[0], '>', val[2]) }
           | expression '<' expression { result = call_on_object(val[0], '<', val[2]) }
           | expression '<=' expression { result = call_on_object(val[0], '<=', val[2]) }
           | expression '>=' expression { result = call_on_object(val[0], '>=', val[2]) }
           | expression '=' expression { result = call_on_object(val[0], '=', val[2]) }
           | expression '!=' expression { result = call_on_object(val[0], '!=', val[2]) }
           | unary_expression
           | term

  hash: LBRACE hash_list RBRACE { result = AST::HashNode.new(@filename, nil, val[1]) }
  hash_list: { result = [] }
           | hash_member { result = val }
           | hash_list COMMA hash_member { result << val }
  hash_member: assignment { result = val[0] }

  array: LBRACKET list RBRACKET { result = AST::ArrayNode.new(@filename, nil, val[1]) }
  list: { result = [] }
      | list_member { result = val }
      | list COMMA list_member { result.push val[2] }
  list_member: expression { result = val[0] }
             | assignment { result = val[0] }


  method_name: IDENTIFIER { result = AST::VarRefNode.new(@filename, nil, val[0].data) }

  term: '@' IDENTIFIER { result = AST::InstanceVarRefNode.new(@filename, nil, "@#{val[1].data}") }
      | '$' IDENTIFIER { result = AST::GlobalVarRefNode.new(@filename, nil, "$#{val[1].data}") }
      | '$' CONSTANT { result = AST::GlobalVarRefNode.new(@filename, nil, "$#{val[1].data}") }
      | IDENTIFIER { result = AST::VarRefNode.new(@filename, nil, val[0].data) }
      | CONSTANT { result = AST::ConstantRefNode.new(@filename, nil, val[0].data) }
      | literal
      | array
      | hash
      | method_call
      | object_call

  literal: FLOAT { result = AST::LiteralNode.new(@filename, nil, val[0].data.to_f) }
         | INTEGER { result = AST::LiteralNode.new(@filename, nil, val[0].data.to_i) }
         | STRING { result = AST::StringNode.new(@filename, nil, val[0].data) }
         | dstring
         | TRUE { result = AST::LiteralNode.new(@filename, nil, true) }
         | FALSE { result = AST::LiteralNode.new(@filename, nil, false) }
         | VOID { result = AST::LiteralNode.new(@filename, nil, nil) }

  dstring: DSTRING_BEGIN dstring_contents DSTRING_END { result = AST::DStringNode.new(@filename, nil, val[1]) }

  dstring_contents: dstring_contents expression { result.push(val[1]) }
                  | expression { result = [val[0]] }

  method_definition: method_name ':' block { result = AST::FunctionDefinitionNode.new(@filename, nil, val[0].variable_name, AST::Function.new(@filename, nil, [], val[2])) }
                   | method_name LPAREN list RPAREN ':' block { result = AST::FunctionDefinitionNode.new(@filename, nil, val[0].variable_name, AST::Function.new(@filename, nil, val[2], val[5])) }

  method_call: term DOT method_name lambda { result = AST::FunctionCallNode.new(@filename, nil, val[0], val[2].variable_name, [], val[3]) }
             | term DOT method_name LPAREN list RPAREN lambda { result = AST::FunctionCallNode.new(@filename, nil, val[0], val[2].variable_name, val[4], val[6]) }
             | method_name LPAREN list RPAREN lambda { result = AST::FunctionCallNode.new(@filename, nil, nil, val[0].variable_name, val[2], val[4]) }
             | term '[' expression RBRACKET { result = AST::FunctionCallNode.new(@filename, nil, val[0], '[]', [val[2]], nil) }

  object_call: CONSTANT LPAREN list RPAREN lambda { result = AST::InstanceInitNode.new(@filename, nil, val[0].data, val[2], val[4]) }

  multiline_lambda: ARROW LPAREN list RPAREN block { result = AST::BlockNode.new(@filename, nil, val[4], val[2]) }
                  | ARROW block { result = AST::BlockNode.new(@filename, nil, val[1], []) }

  singleline_lambda: ARROW LPAREN list RPAREN LBRACE statement RBRACE { result = AST::BlockNode.new(@filename, nil, [val[5]], val[2]) }
                   | ARROW LBRACE statement RBRACE { result = AST::BlockNode.new(@filename, nil, [val[2]], []) }
  lambda: { result = nil }
        | multiline_lambda { result = val[0] }
        | singleline_lambda { result = val[0] }

---- header
%w(
  node root_node function_call_node function_definition_node function_node
  string_node literal_node var_ref_node if_node assignment_node while_node
  class_definition_node instance_init_node block_node hash_node array_node
  unary_function_call_node constant_ref_node instance_var_ref_node
  dstring_node begin_block_node rescue_block_node global_var_ref_node
).each { |node| require_relative "../dagon/ast/#{node}" }

---- inner

  def initialize(tokens, filename, debug = false, &error_handler)
    @yydebug = debug
    @filename = filename
    @tokens = tokens
    @line = 0
    @error_handler = error_handler if block_given?
  end

  def parse
    do_parse
  end

  def self.parse(tokens, filename, debug = false, &on_error)
    new(tokens, filename, debug, &on_error).parse
  end

  private
  attr_accessor :tokens
  def next_token
    tokens.shift
  end

  def on_error error_token_id, error_value, value_stack
    message = "#{@filename}:#{error_value.line}: syntax error, unexpected #{error_value.data.inspect}"
    if @error_handler
      @error_handler.call(message, value_stack)
    else
      $stderr.puts message, value_stack.inspect
      exit
    end
  end

  def call_on_object(object, method, *args)
    AST::FunctionCallNode.new(@filename, nil, object, method, args, nil)
  end
