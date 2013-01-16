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
  def initialize
    @table = [:program]
  end

  def parse
    do_parse
    self
  end

  def next_token
    @tokens.shift
  end
---- footer
  describe Ast::Generator, 'parse' do
    describe 'assignment' do
      it 'handles floats' do
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
