require 'singleton'

module Dagon
  class Environment
    include Singleton

    def initialize
      @defines = {
        binding: Dagon::Method.new('binding') { |*args| Dagon::Environment.instance.scope },
        gets: Dagon::Method.new('gets') { |*args| Dagon::DString.new($stdin.gets.chomp) },
        puts: Dagon::Method.new('puts') { |*args| puts *args.map(&:to_s) },
        print: Dagon::Method.new('print') { |*args| print *args.map(&:to_s) },
        eval: Dagon::Method.new('eval') do |*args|
          string = args[0]
          scope = args[1]
          scope = scope || Environment.instance.scope.dup
          tokenizer = Tokenizer.new
          tokens = tokenizer.tokenize(string.value)
          ast = Ast::Generator.new(tokens).parse.table
          code = ast[1]
          code.each do |statement|
            Statement.new(statement, scope).reduce
          end
        end
      }
    end

    def scope
      DScope.new(@defines)
    end
  end
end
