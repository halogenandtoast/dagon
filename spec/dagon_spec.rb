$: << File.expand_path('../..', __FILE__)
require 'build/scanner'
require 'build/parser'
require 'yaml'

EXAMPLES =  YAML.load(File.open(File.expand_path("../examples.yaml", __FILE__)))

describe Dagon::Scanner do
  EXAMPLES.each do |dagon, extra|
    it dagon do
      Dagon::Scanner.tokenize(dagon).should == eval(extra[0])
    end
  end
end

describe Dagon::Parser do
  EXAMPLES.each do |dagon, extra|
    it dagon do
      Dagon::Parser.new(eval(extra[0])).parse.table.should == eval(extra[1])
    end
  end
end
