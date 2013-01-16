class Ast::Generator
rule
  program: assignment
         | program NEWLINE assignment

  literal: FLOAT { result = [:float, val[0].to_f] }
         | INTEGER { result = [:integer, val[0].to_i] }

  assignment: IDENTIFIER ':' ' ' literal {
                table << [:assignment,
                          [:identifier, val[0]],
                          val[3]
                        ]
                }
            | IDENTIFIER ':' ' ' IDENTIFIER # x: y
end

---- header
---- inner
  attr_accessor :table
  def initialize(tokens)
    @table = [:program]
    @tokens = tokens
  end

  def parse
    do_parse
    self
  end

  def next_token
    tokens.shift
  end

  private
  attr_accessor :tokens
---- footer
  describe Ast::Generator, 'parse' do
    describe 'assignment' do
      it 'handles integers' do
        # y: 4
        tokens = [
          [:IDENTIFIER, 'y'],
          [":", ":"],
          [" ", " "],
          [:INTEGER, "4"],
        ]
        generate(tokens).should == [
          :program,
          [:assignment,
            [:identifier, 'y'],
            [:integer, 4]
          ]
        ]
      end

      it 'handles floats' do
        # x: 5.0
        tokens = [
          [:IDENTIFIER, 'x'],
          [":", ":"],
          [" ", " "],
          [:FLOAT, "5.0"],
        ]
        generate(tokens).should == [
          :program,
          [:assignment,
            [:identifier, 'x'],
            [:float, 5.0]
          ]
        ]
      end
    end
  end

  def generate(tokens)
    Ast::Generator.new(tokens).parse.table
  end
