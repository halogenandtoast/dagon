require 'spec_helper'
require 'build/ast/generator'

describe Ast::Generator, 'parse' do
  describe 'assignment' do
    it 'handles integers' do
      generate("y: 4").should == [
        :program, [
          [:assignment, [:identifier, 'y'], [:integer, 4]],
        ]
      ]
    end

    it 'handles floats' do
      generate("x: 5.0").should == [
        :program, [
          [:assignment, [:identifier, 'x'], [:float, 5.0]],
        ]
      ]
    end

    it 'handles literals' do
      generate("x: y").should == [
        :program, [
          [:assignment, [:identifier, 'x'], [:identifier, 'y']],
        ]
      ]
    end
  end

  {
    addition: '+',
    subtraction: '-',
    multiplication: '*',
    division: '/',
    exponentiation: '**'
  }.each do |description, operator|
    describe "statements #{description}" do
      it "handles integer #{description}" do
        generate("8 #{operator} 4").should == [
          :program, [
            [description, [:integer, 8], [:integer, 4]],
          ]
        ]
      end
    end
  end

  describe 'a personal failing' do
    it "has some trouble with nested expressions" do
      generate("1 + 2 + 3").should == [
        :program,
        [:addition, [:addition, [:integer, 1], [:integer, 2]], [:integer, 3]]
      ]
    end
  end

  describe 'method call' do
    it 'calls puts with argument 1' do
      generate("puts(1)").should == [
        :program, [
          [:call, [:identifier, 'puts'], [:args, [[:integer, 1]]]],
        ]
      ]
    end

    it 'can be called with a method call as an argument' do
      generate("puts(translate(1))").should == [
        :program, [
          [:call, [:identifier, 'puts'], [:args, [[:call, [:identifier, 'translate'], [:args, [[:integer, 1]]]]]]],
        ]
      ]
    end

    it 'can take assignment as an argument' do
      generate("puts(4 + 2)").should == [
        :program, [
          [:call, [:identifier, 'puts'], [:args, [[:addition, [:integer, 4], [:integer, 2]]]]],
        ]
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
    '1 + 2 + 3' => [[:INTEGER, '1'], [' ', ' '], ['+', '+'], [' ', ' '], [:INTEGER, '2'], [' ', ' '], ['+', '+'], [' ', ' '], [:INTEGER, '3']],
    '8 - 4' => [[:INTEGER, '8'], [' ', ' '], ['-', '-'], [' ', ' '], [:INTEGER, '4']],
    '8 * 4' => [[:INTEGER, '8'], [' ', ' '], ['*', '*'], [' ', ' '], [:INTEGER, '4']],
    '8 / 4' => [[:INTEGER, '8'], [' ', ' '], ['/', '/'], [' ', ' '], [:INTEGER, '4']],
    '8 ** 4' => [[:INTEGER, '8'], [' ', ' '], ['**', '**'], [' ', ' '], [:INTEGER, '4']],
    'puts(1)' => [[:IDENTIFIER, 'puts'], [:LPAREN, '('], [:INTEGER, '1'], [:RPAREN, ')']],
    'puts(translate(1))' => [[:IDENTIFIER, 'puts'], [:LPAREN, '('], [:IDENTIFIER, 'translate'], [:LPAREN, '('], [:INTEGER, '1'], [:RPAREN, ')'], [:RPAREN, ')']],
    'puts(4 + 2)' => [[:IDENTIFIER, 'puts'], [:LPAREN, '('], [:INTEGER, '4'], [' ', ' '], ['+', '+'], [' ', ' '], [:INTEGER, '2'], [:RPAREN, ')']],
  }.fetch(code) { raise %{"#{code}": No token definition.}}
end
