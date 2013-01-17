module Dagon
  class Environment
    attr_reader :methods
    def initialize
      @methods = {
        puts: Dagon::Method.new('puts') { |*args| puts *args }
      }
    end

    def error string
      $stderr.puts string
      exit
    end
  end
  class Interpreter
    def initialize ast
      @ast = ast
    end

    def run
      environment = Environment.new
      program = Program.new(@ast, environment)
      program.run
    end
  end

  class Node
    attr_reader :environment, :ast
    def initialize ast, environment
      @ast = ast
      @environment = environment
    end

    def next_node
      ast.shift
    end

    def error string
      environment.error string
    end
  end

  class Program < Node
    def run
      if next_node != :program
        error "Invalid program"
      end

      statements = next_node

      statements.each do |node|
        case node[0]
        when :call
          call = Call.new(node, environment)
          call.run
        end
      end
    end
  end

  class Call < Node
    def run
      if next_node != :call
        error "Invalid call"
      end

      identifier = Identifier.new(next_node, environment)
      expression = Expression.new(next_node, environment)
      method = identifier.lookup
      method.invoke(expression.reduce)
    end

  end

  class Identifier < Node
    def lookup
      if (node = next_node) != :identifier
        error "Invalid identifier #{node}"
      end
      environment.methods[next_node.to_sym]
    end
  end

  class Expression < Node
    def reduce
      type = next_node
      value = next_node
      case type
      when :integer
        value
      else
        error "Unknown type: #{type}"
      end
    end
  end

  class Method
    def initialize name, &block
      @name = name
      @block = block
    end

    def invoke *args
      @block.call(*args)
    end
  end
end
