require 'pry'
CORE = %w(environment object class method integer block string array true false scope)

AST = %w(node statement program call identifier
         expression assignment block
         conditional_statement while_statement
         condition constant class_definition)

CORE.each do |file|
  require_relative "./core/#{file}"
end

AST.each do |file|
  require_relative "./ast/#{file}"
end

module Dagon
  class Interpreter
    def initialize ast
      @ast = ast
    end

    def run
      environment = Dagon::Core::Environment.instance
      program = Dagon::Ast::Program.new(@ast, environment.scope)
      program.run
    end
  end
end
