module Dagon
  class Binding
    def error string
      $stderr.puts string
      exit
    end
  end

  class Environment < Binding
    attr_reader :methods
    def initialize
      @methods = {
        puts: Dagon::Method.new('puts') { |*args| puts *args },
        print: Dagon::Method.new('print') { |*args| print *args },
      }
    end
  end

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

  class Node
    attr_reader :binding, :ast
    def initialize ast, binding
      @ast = ast
      @binding = binding
    end

    def next_node
      ast.shift
    end

    def error string
      binding.error string
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
          call = Call.new(node, binding)
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

      identifier = Identifier.new(next_node, binding)
      expression = Expression.new(next_node, binding)
      method = identifier.lookup
      method.invoke(expression.reduce)
    end

  end

  class Identifier < Node
    def lookup
      if (node = next_node) != :identifier
        error "Invalid identifier #{node}"
      end
      binding.methods[next_node.to_sym]
    end
  end

  class Expression < Node
    def reduce
      type = next_node
      value = next_node
      case type
      when :integer
        value
      when :addition
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:+, lhs, rhs).reduce
      when :subtraction
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:-, lhs, rhs).reduce
      when :multiplication
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:*, lhs, rhs).reduce
      when :division
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:/, lhs, rhs).reduce
      else
        error "Unknown type: #{type}"
      end
    end
  end

  class Operation
    def initialize operator, lhs, rhs
      @operator = operator
      @lhs, @rhs = lhs, rhs
    end

    def reduce
      @lhs.send(@operator, @rhs)
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
