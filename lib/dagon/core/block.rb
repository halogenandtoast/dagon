module Dagon
  module Core
    class Block < Dagon::Core::Object

      def initialize statements, scope, args = []
        @statements = statements
        @scope = scope
        @args = args.compact
      end

      def invoke *args
        assignments = @args.zip(args)
        assignments.each do |name, value|
          scope.define(name.to_sym, value)
        end
        statements.each do |statement|
          Dagon::Ast::Statement.new(statement, scope).compile
        end
      end

      def inspect
        @statements.map(&:inspect)
      end

      private

      attr_reader :scope, :statements, :variables
    end
  end
end
