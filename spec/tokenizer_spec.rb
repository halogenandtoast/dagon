require 'spec_helper'
require 'build/tokenizer'

describe Dagon::Tokenizer do
  it "can #tokenize things" do
    tokenizer = Dagon::Tokenizer.new
    examples = {
      'x: 5.0' => [[:IDENTIFIER, 'x'], [':', ':'], [' ', ' '], [:FLOAT, '5.0'], [:EOF, 'EOF']],
      'y: 4' => [[:IDENTIFIER, 'y'], [':', ':'], [' ', ' '], [:INTEGER, '4'], [:EOF, 'EOF']],
      'x: y' => [[:IDENTIFIER, 'x'], [':', ':'], [' ', ' '], [:IDENTIFIER, 'y'], [:EOF, 'EOF']],
      '8 + 4' => [[:INTEGER, '8'], [' ', ' '], ['+', '+'], [' ', ' '], [:INTEGER, '4'], [:EOF, 'EOF']],
      '1 + 2 + 3' => [[:INTEGER, '1'], [' ', ' '], ['+', '+'], [' ', ' '], [:INTEGER, '2'], [' ', ' '], ['+', '+'], [' ', ' '], [:INTEGER, '3'], [:EOF, 'EOF']],
      '8 - 4' => [[:INTEGER, '8'], [' ', ' '], ['-', '-'], [' ', ' '], [:INTEGER, '4'], [:EOF, 'EOF']],
      '8 * 4' => [[:INTEGER, '8'], [' ', ' '], ['*', '*'], [' ', ' '], [:INTEGER, '4'], [:EOF, 'EOF']],
      '8 / 4' => [[:INTEGER, '8'], [' ', ' '], ['/', '/'], [' ', ' '], [:INTEGER, '4'], [:EOF, 'EOF']],
      '8 ** 4' => [[:INTEGER, '8'], [' ', ' '], ['**', '**'], [' ', ' '], [:INTEGER, '4'], [:EOF, 'EOF']],
      'puts(1)' => [[:IDENTIFIER, 'puts'], [:LPAREN, '('], [:INTEGER, '1'], [:RPAREN, ')'], [:EOF, 'EOF']],
      'puts(translate(1))' => [[:IDENTIFIER, 'puts'], [:LPAREN, '('], [:IDENTIFIER, 'translate'], [:LPAREN, '('], [:INTEGER, '1'], [:RPAREN, ')'], [:RPAREN, ')'], [:EOF, 'EOF']],
      'puts(4 + 2)' => [[:IDENTIFIER, 'puts'], [:LPAREN, '('], [:INTEGER, '4'], [' ', ' '], ['+', '+'], [' ', ' '], [:INTEGER, '2'], [:RPAREN, ')'], [:EOF, 'EOF']],
      "MyClass:\n  x: 1" => [[:CONSTANT, 'MyClass'], [':', ':'], [:INDENT, '  '], [:IDENTIFIER, 'x'], [':', ':'], [' ', ' '], [:INTEGER, '1'], [:DEDENT, '  '], [:EOF, 'EOF']]
    }

    examples.each do |program, expectation|
      tokenizer.tokenize(program).should == expectation
    end
  end
end
