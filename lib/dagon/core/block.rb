module Dagon
  module Core
    class Block < Dagon::Core::Object
      def initialize statements, scope, args = []
        @statements = statements
        @scope = Scope.new(self, scope)
        @args = args.compact
        @value = ->(*args) { self.invoke(*args) }
      end

      def invoke(*args)
        if args.first.is_a? Hash
          args = args.first
          unless @args.sort == args.keys.sort
            raise <<-ERROR
Invalid arguments:
  expected: #{@args.sort.inspect}
  got:      #{args.keys.sort.inspect}
            ERROR
          end
          assignments = args
        else
          assignments = @args.zip(args)
        end
        assignments.each do |name, value|
          scope.define(name.to_sym, value)
        end
        statements.map do |statement|
          Dagon::Ast::Statement.new(statement, scope).compile
        end.last
      end

      def inspect
        "#<Block: #{@statements.map(&:inspect)}>"
      end

      private

      attr_reader :statements
    end
  end
end
