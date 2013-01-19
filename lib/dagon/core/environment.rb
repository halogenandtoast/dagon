require 'singleton'

module Dagon
  module Core
    class Environment
      include Singleton

      def binding
        scope
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

      def eval *args
        string = args[0]
        eval_scope = args[1]
        eval_scope ||= scope.dup
        tokenizer = Tokenizer.new
        tokens = tokenizer.tokenize(string.value)
        ast = Ast::Generator.new(tokens).parse.table
        statements = ast[1]
        statements.each do |statement|
          Ast::Statement.new(statement, scope).reduce
        end
      end

      def scope
        @scope ||= Dagon::Core::Scope.new(self)
      end
    end
  end
end
