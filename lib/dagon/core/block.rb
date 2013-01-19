module Dagon
  module Core
    class Block < Dagon::Core::Object
      def initialize statements, scope
        @statements = statements
        @scope = scope
      end

      def invoke *args
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

      attr_reader :scope, :statements
    end
  end
end
