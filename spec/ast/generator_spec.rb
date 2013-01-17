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
        [:assignment, [:identifier, 'x'], [:float, 5.0]]
      ]
    end

    it 'handles literals' do
      generate("x: y").should == [
        :program,
        [:assignment, [:identifier, 'x'], [:identifier, 'y']]
      ]
    end
  end

  describe 'addition' do
    it 'handles integer addition' do
      generate("8 + 4").should == [
        :program,
        [:addition, [:integer, 8], [:integer, 4]]
      ]
    end
  end

  describe 'method call' do
    it 'calls puts with argument 1' do
      generate("puts(1)").should == [
        :program,
        [:call, [:identifier, 'puts'], [:integer, 1]]
      ]
    end

    it 'can be called with a method call as an argument' do
      generate("puts(translate(1))").should == [
        :program,
        [:call, [:identifier, 'puts'], [:call, [:identifier, 'translate'], [:integer, 1]]]
      ]
    end
  end
end

def generate(dagon)
  tokens = tokenize(dagon)
  Ast::Generator.new(tokens).parse.table
end

def tokenize(code)
  {
    'x: 5.0' => [[:IDENTIFIER, 'x'], [':', ':'], [' ', ' '], [:FLOAT, '5.0']],
    'y: 4' => [[:IDENTIFIER, 'y'], [':', ':'], [' ', ' '], [:INTEGER, '4']],
    'x: y' => [[:IDENTIFIER, 'x'], [':', ':'], [' ', ' '], [:IDENTIFIER, 'y']],
    '8 + 4' => [[:INTEGER, '8'], [' ', ' '], ['+', '+'], [' ', ' '], [:INTEGER, '4']],
    'puts(1)' => [[:IDENTIFIER, 'puts'], [:OPEN_PAREN, '('], [:INTEGER, '1'], [:CLOSE_PAREN, ')']],
    'puts(translate(1))' => [[:IDENTIFIER, 'puts'], [:OPEN_PAREN, '('], [:IDENTIFIER, 'translate'], [:OPEN_PAREN, '('], [:INTEGER, '1'], [:CLOSE_PAREN, ')'], [:CLOSE_PAREN, ')']],
  }.fetch(code) { raise %{"#{code}": No token definition.}}
end
