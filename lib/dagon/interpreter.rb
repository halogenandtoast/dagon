module Dagon
  class Interpreter
    def initialize ast
      @ast = ast
    end

    def run
      program = Program.new(@ast)
      program.run
    end
  end

  class Program
    def initialize ast
      @ast = ast
    end

    def error string
      $stderr.puts string
    end

    def run
      if next_node != :program
        error "Invalid program"
      end

      node = next_node

      case node[0]
      when :call
        call = Call.new(node)
        call.run
      end
    end

    def next_node
      @ast.shift
    end
  end

  class Call
    def initialize ast
      @ast = ast
    end

    def run
      if next_node != :call
        error "Invalid call"
      end

      identifier = Identifier.new(next_node)
      expression = Expression.new(next_node)
      method = identifier.lookup
      method.invoke(expression.reduce)
    end

    def next_node
      @ast.shift
    end
  end

  class Identifier
    def initialize ast
      @ast = ast
    end

    def lookup
      if (node = next_node) != :identifier
        puts "Invalid identifier #{node}"
        exit
      end
      $methods[next_node.to_sym]
    end

    def next_node
      @ast.shift
    end
  end

  class Expression
    def initialize ast
      @ast = ast
    end

    def reduce
      type = next_node
      value = next_node
      case type
      when :integer
        value
      else
        puts "Unknown type: #{type}"
        exit
      end
    end

    def next_node
      @ast.shift
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

$methods = {
  puts: Dagon::Method.new('puts') { |*args| puts *args }
}
