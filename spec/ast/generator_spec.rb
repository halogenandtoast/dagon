require 'spec_helper'
require 'build/ast/generator'

describe Ast::Generator, 'parse' do
  describe 'assignment' do
    it 'handles integers' do
      generate("y: 4").should == [
        :program,
        [:assignment,
          [:identifier, 'y'],
          [:integer, 4]
        ]
      ]
    end

    it 'handles floats' do
      generate("x: 5.0").should == [
        :program,
        [:assignment,
          [:identifier, 'x'],
          [:float, 5.0]
        ]
      ]
    end
  end
end

def generate(dagon)
  tokens = tokenize[dagon]
  Ast::Generator.new(tokens).parse.table
end

def tokenize
  {
    "x: 5.0" => [
      [:IDENTIFIER, 'x'],
      [":", ":"],
      [" ", " "],
      [:FLOAT, "5.0"],
    ],
    "y: 4" => [
      [:IDENTIFIER, 'y'],
      [":", ":"],
      [" ", " "],
      [:INTEGER, "4"],
    ],
  }
end
