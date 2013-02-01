require 'singleton'

module Dagon
  module Core
    class Environment
      include Singleton

      def initialize
        @method_table = {}
      end

      def define_dagon_method name, code_block
        @method_table[name] = ->(*args) { code_block.invoke(*args) }
      end

      def binding
        scope
      end

      def exit
        Kernel.exit
      end

      def gets
        Dagon::Core::String.new($stdin.gets.chomp)
      end

      def puts *args
        $stdout.puts(*args.map(&:to_s))
      end

      def print *args
        $stdout.print(*args.map(&:to_s))
      end

      def require filename
        contents = File.read("#{$dagon_cwd}/#{filename.value}.dg")
        self.eval(Dagon::Core::String.new(contents))
      end

      def eval *args
        string = args[0]
        eval_scope = args[1]
        eval_scope ||= scope.dup
        tokenizer = Tokenizer.new
        tokens = tokenizer.tokenize(string.value)
        ast = Ast::Generator.new(tokens).parse.table
        statements = ast[1]
        statements.map do |statement|
          Ast::Statement.new(statement, scope).compile
        end.last
      end

      def scope
        @scope ||= Dagon::Core::Scope.new(self)
      end
    end
  end
end
