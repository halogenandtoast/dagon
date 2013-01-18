# vim: set syntax=ruby:

=begin
%%{
  machine new_parser;
  constant = upper (alnum | '-')*;
  identifier = lower (lower | digit | '-')*;
  assignment = ': ';
  colon = ':';
  operator = ' + ' | ' - ' | ' * ' | ' / ';
  exponent = ' ** ';
  lparen = '(';
  rparen = ')';
  lbracket = '[';
  rbracket = ']';
  comma = ',';
  dot = '.';
  float = digit+ '.' digit+;
  integer = digit+;
  newline = "\r"? "\n" | "\r";
  double_quote = "\"";
  indent = "  ";

  main := |*
    constant => { emit(:CONSTANT, data, ts, te) };
    identifier => { emit(:IDENTIFIER, data, ts, te) };
    assignment => { emit(:ASSIGNMENT, data, ts, te-1) };
    colon => { emit(':', data, ts, te) };
    float => { emit(:FLOAT, data, ts, te) };
    integer => { emit(:INTEGER, data, ts, te) };
    newline { @last_indent_count = @indent_count; @indent_count = 0; @line += 1; @column = 0; @check_indents = true };
    indent => { @indent_count += 1; };
    space => { emit(' ', data, ts, te) };
    lparen => { emit(:LPAREN, data, ts, te) };
    rparen => { emit(:RPAREN, data, ts, te) };
    lbracket => { emit(:LBRACKET, data, ts, te) };
    rbracket => { emit(:RBRACKET, data, ts, te) };
    dot => { emit(:DOT, data, ts, te) };
    operator => { emit(data[(ts+1)...(te-1)], data, ts + 1, te - 1) };
    exponent => { emit(:EXPONENT, data, ts + 1, te - 1) };
    double_quote => { emit(:DOUBLE_QUOTE, data, ts, te) };
    comma => { emit(:COMMA, data, ts, te) };

    any => { problem(data, ts, te) };
  *|;
}%%
=end

module Dagon
  class Tokenizer
    %% write data;
    # % fix syntax highlighting

    def self.emit(name, data, start_char, end_char)
      handle_indents
      @tokens << [name, data[start_char...end_char]]
      @column += end_char - start_char
    end

    def self.handle_indents
      if @check_indents
        @check_indents = false
        if @indent_count > @last_indent_count
          (@indent_count - @last_indent_count).times do
            @tokens << [:INDENT, "  "]
          end
        elsif @indent_count < @last_indent_count
          (@last_indent_count - @indent_count).times do
            @tokens << [:DEDENT, "  "]
          end
        end
      end
    end

    def self.problem(data, ts, te)
      puts @tokens.inspect
      raise "Oops {#{data[ts...-1]}}"
    end

    def tokenize data
      self.class.tokenize(data)
    end

    def self.reset
      @line = 0
      @column = 0
      @tokens = []
      @indent_count = 0
      @last_indent_count = 0
      @check_indents = true
    end

    def self.tokenize(data)
      reset
      %% write init;
      eof = data.length
      %% write exec;
      @check_indents = true
      @last_indent_count = @indent_count
      @indent_count = 0
      handle_indents
      @tokens << [:EOF, "EOF"]
      @tokens
    end
  end
end
