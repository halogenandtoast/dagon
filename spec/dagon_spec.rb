$: << File.expand_path('../..', __FILE__)
require 'build/tokenizer'
require 'lib/dagon/interpreter'
require 'build/ast/generator'
require 'yaml'

EXAMPLES =  YAML.load(File.open(File.expand_path("../examples.yaml", __FILE__)))

describe Dagon::Tokenizer do
  EXAMPLES.each do |dagon, extra|
    it dagon do
      Dagon::Tokenizer.reset
      Dagon::Tokenizer.tokenize(dagon).should == eval(extra[0])
    end
  end
end

describe Dagon::Ast::Generator do
  EXAMPLES.each do |dagon, extra|
    it dagon do
      Dagon::Ast::Generator.new(eval(extra[0])).parse.table.should == eval(extra[1])
    end
  end
end
