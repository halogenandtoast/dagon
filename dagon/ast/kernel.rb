module Dagon
  class Kernel
    def initialize core
      @core = core # pass by object ftw?
    end

    def require file
      filename = "#{$dagon_cwd}/#{file}.dg"
      program = File.read(filename)
      tokenizer = Dagon::Tokenizer.new
      tokens = tokenizer.tokenize program, filename
      tree = Dagon::Ast::Generator.new(tokens).parse
      tree.evaluate(@core)
    end
  end
end
