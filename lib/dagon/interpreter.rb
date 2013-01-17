require_relative 'interpreter/binding'
require_relative 'interpreter/environment'
require_relative 'interpreter/node'
require_relative 'interpreter/statement'
require_relative 'interpreter/program'
require_relative 'interpreter/call'
require_relative 'interpreter/identifier'
require_relative 'interpreter/expression'
require_relative 'interpreter/operation'
require_relative 'interpreter/assignment'
require_relative 'interpreter/method'
require_relative 'interpreter/dobject'
require_relative 'interpreter/dinteger'
require_relative 'interpreter/block'

module Dagon
  class Interpreter
    def initialize ast
      @ast = ast
    end

    def run
      binding = Environment.new
      program = Program.new(@ast, binding)
      program.run
    end
  end
end
