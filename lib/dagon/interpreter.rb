%w(binding environment node statement program call identifier
   expression operation assignment method dobject dinteger
   block dclass dstring darray).each do |file|
    require_relative "interpreter/#{file}"
   end

module Dagon
  class Interpreter
    def initialize ast
      @ast = ast
    end

    def run
      environment = Environment.instance
      program = Program.new(@ast, environment.binding)
      program.run
    end
  end
end
