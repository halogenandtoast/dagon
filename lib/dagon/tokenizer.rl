# vim: set syntax=ruby:

=begin
%%{
  machine new_parser;
  newline = "\r"? "\n" | "\r";
  newlines = newline+;
  keyword = 'if' | 'elseif' | 'else' | 'while' | 'true' | 'false';
  string = '"' ( [^"\\] | /\\./ )* '"';
  comment = '#' (any - newline)* newline;
  constant = upper (alnum | '-')*;
  identifier = lower (lower | digit | '-')*;
  assignment = ': ';
  colon = ':';
  operator = ' + ' | ' - ' | ' * ' | ' / ' | ' = ' | ' != ' | ' < ' | ' > ' | ' <= ' | ' >= ';
  exponent = ' ** ';
  lparen = '(';
  rparen = ')';
  lbracket = '[';
  rbracket = ']';
  lbrace = '{';
  rbrace = '}';
  comma = ', ';
  dot = '.';
  float = digit+ '.' digit+;
  integer = digit+;
  indent = "  ";

  main := |*
    newlines { @last_indent_count = @indent_count; @indent_count = 0; @line += data[ts...te].lines.count; @column = 0; @check_indents = true };
    comment { handle_indents };
    keyword => { emit(data[ts...te].upcase.to_sym, data, ts, te) };
    string => { emit_string(data, ts, te) };
    constant => { emit(:CONSTANT, data, ts, te) };
    identifier => { emit(:IDENTIFIER, data, ts, te) };
    assignment => { emit(:ASSIGNMENT, data, ts, te-1) };
    colon => { emit(':', data, ts, te) };
    float => { emit(:FLOAT, data, ts, te) };
    integer => { emit(:INTEGER, data, ts, te) };
    indent => { @indent_count += 1; };
    lparen => { emit(:LPAREN, data, ts, te) };
    rparen => { emit(:RPAREN, data, ts, te) };
    lbrace => { emit(:LBRACE, data, ts, te) };
    rbrace => { emit(:RBRACE, data, ts, te) };
    lbracket => { emit(:LBRACKET, data, ts, te) };
    rbracket => { emit(:RBRACKET, data, ts, te) };
    dot => { emit(:DOT, data, ts, te) };
    operator => { emit(data[(ts+1)...(te-1)], data, ts + 1, te - 1) };
    exponent => { emit(:EXPONENT, data, ts + 1, te - 1) };
    comma => { emit(:COMMA, data, ts, te) };
    space;

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
      @tokens << [name, data[start_char...end_char], [@line]]
      @column += end_char - start_char
    end

    def self.emit_string(data, start_char, end_char)
      handle_indents
      str = data[(start_char+1)...(end_char-1)].gsub(/\\(.)/) { $1 }
      @tokens << [:STRING, str, [@line]]
      @column += end_char - start_char
    end

    def self.handle_indents
      if @check_indents
        @check_indents = false
        if @indent_count > @last_indent_count
          (@indent_count - @last_indent_count).times do
            @tokens << [:INDENT, "  ", [@line]]
          end
        elsif @indent_count < @last_indent_count
          (@last_indent_count - @indent_count).times do
            @tokens << [:DEDENT, "  ", [@line]]
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
      if @indent_count != 0
        @last_indent_count = @indent_count
        @indent_count = 0
      end
      handle_indents
      @tokens
    end
  end
end
