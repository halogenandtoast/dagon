module Dagon
  class Kernel
    def initialize core
      @core = core # pass by object ftw?
    end

    def require file
      program = File.read("#{$dagon_cwd}/#{file}.dg")
      tokenizer = Dagon::Tokenizer.new
      tokens = tokenizer.tokenize program
      tree = Dagon::Ast::Generator.new(tokens).parse
      tree.evaluate(@core)
    end
  end
end
