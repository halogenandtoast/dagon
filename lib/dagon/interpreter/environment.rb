require 'singleton'

module Dagon
  class Environment
    include Singleton

    def initialize
      @defines = {
        gets: Dagon::Method.new('gets') { |*args| Dagon::DString.new($stdin.gets) },
        puts: Dagon::Method.new('puts') { |*args| puts args.map(&:to_s) },
        print: Dagon::Method.new('print') { |*args| print args.map(&:to_s) },
        eval: Dagon::Method.new('eval') do |*args|
          string = args[0]
          binding = args[1]
          binding = binding || Environment.instance.binding.dup
          tokenizer = Tokenizer.new
          tokens = tokenizer.tokenize(string.value)
          ast = Ast::Generator.new(tokens).parse.table
          code = ast[1]
          code.each do |statement|
            Statement.new(statement, binding).reduce
          end
        end
      }
    end

    def binding
      DBinding.new(@defines)
    end
  end
end
