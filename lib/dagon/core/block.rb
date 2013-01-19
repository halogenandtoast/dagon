module Dagon
  module Core
    class Block < Dagon::Core::Object
      def initialize statements, scope, variables=[]
        @statements = statements
        @scope = scope
        @variables = variables
      end

      def invoke *args
        assignments = variables.zip(args)
        assignments.each do |variable, value|
          scope.define(variable.to_sym, value)
        end
        statements.each do |statement|
          Dagon::Ast::Statement.new(statement, scope).reduce
        end
      end

      def reduce
        invoke
      end

      def inspect
        @statements.map(&:inspect)
      end

      private

      attr_reader :scope, :statements, :variables
    end
  end
end
