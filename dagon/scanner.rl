# vim: set syntax=ruby:

=begin
%%{
  machine new_parser;
  newline = ("\r"? "\n" | "\r") %{ @last_was_newline = true };
  keyword = 'if' | 'elseif' | 'else' | 'while' | 'true' | 'false' | 'void' | 'begin' | 'rescue';
  string = '"' ( /#{[^}]*}/ | [^"\\] | /\\./ )* '"';
  comment = '#' (any - newline)* newline %{ @line += 1 };
  constant = upper (alnum | '_')*;
  identifier = '-'? lower (lower | digit | '-')*;
  assignment = ': ';
  arrow = '->';
  colon = ':';
  operator = ' + ' | ' - ' | ' * ' | ' / ' | ' = ' | ' != ' | ' < ' | ' > ' | ' <= ' | ' >= ' | ' && ' | ' || ' | ' ^ ';
  exponent = ' ** ';
  lparen = '(';
  rparen = ')';
  lbracket = '[';
  rbracket = ']';
  lbrace = '{';
  rbrace = '}';
  comma = ', ';
  bang = '!';
  dot = '.';
  float = digit+ '.' digit+;
  integer = '-'? digit+;
  indent = "  "+;
  at = "@";
  dollar = "$";

  main := |*
    comment;
    indent => { indent(data, ts, te) };
    newline => { newline; @line += 1 };
    keyword => { emit(data[ts...te].upcase.to_sym, data, ts, te) };
    string => { parse_string(data, ts, te) };
    constant => { emit(:CONSTANT, data, ts, te) };
    identifier => { emit(:IDENTIFIER, data, ts, te) };
    assignment => { emit(:ASSIGNMENT, data, ts, te-1) };
    arrow => { emit(:ARROW, data, ts, te) };
    colon => { emit(':', data, ts, te) };
    float => { emit(:FLOAT, data, ts, te) };
    integer => { emit(:INTEGER, data, ts, te) };
    lparen => { emit(:LPAREN, data, ts, te) };
    rparen => { emit(:RPAREN, data, ts, te) };
    lbrace => { emit(:LBRACE, data, ts, te) };
    rbrace => { emit(:RBRACE, data, ts, te) };
    lbracket => { emit(:LBRACKET, data, ts, te) };
    rbracket => { emit(:RBRACKET, data, ts, te) };
    dot => { emit(:DOT, data, ts, te) };
    bang => { emit('!', data, ts, te) };
    at => { emit('@', data, ts, te) };
    dollar => { emit('$', data, ts, te) };
    operator => { emit(data[(ts+1)...(te-1)], data, ts + 1, te - 1) };
    exponent => { emit(:EXPONENT, data, ts + 1, te - 1) };
    comma => { emit(:COMMA, data, ts, te) };
    space;

    any => { problem(data, ts, te); fbreak; };
  *|;
}%%
=end

require 'stringio'
require 'dagon/string_tokenizer'

module Dagon
  class Token < Struct.new(:data, :line)
    def to_s
      data.inspect
    end

    def inspect
      data.inspect
    end
  end
  class Scanner

    def initialize
      %% write data;
      # % fix syntax highlighting
    end

    def newline
      if !@tokens.empty? && @tokens.last[0] != :NEWLINE
        @tokens << [:NEWLINE, Token.new("\n", @line)]
      end
    end

    def pop_newlines
      while @tokens.last && @tokens.last[0] == :NEWLINE
        @tokens.pop
      end
    end

    def indent data, ts, te
      @last_was_newline = false
      indent_count = (te - ts) / 2
      if indent_count > @current_indents
        pop_newlines
        (indent_count - @current_indents).times do
          @tokens << [:INDENT, Token.new("<indent>", @line)]
        end
      end
      if @current_indents > indent_count
        pop_newlines
        newline
        (@current_indents - indent_count).times do
          @tokens << [:DEDENT, Token.new("<dedent>", @line)]
          newline
        end
        newline
      end
      @current_indents = indent_count
    end

    def emit(name, data, start_char, end_char)
      if name == :ELSE || name == :ELSEIF
        pop_newlines
      end
      if name == :RESCUE && @tokens.last && @tokens.last[0] == :NEWLINE
        pop_newlines
      end
      if @last_was_newline
        @current_indents.times do
          @tokens << [:DEDENT, Token.new("<dedent>", @line)]
          newline
        end
        @current_indents = 0
      end
      @last_was_newline = false
      if @tokens.last && @tokens.last[0] == :IDENTIFIER && name == :LBRACKET
        @tokens << ['[', Token.new(data[start_char...end_char], @line)]
      else
        @tokens << [name, Token.new(data[start_char...end_char], @line)]
      end
      @column += end_char - start_char
    end

    def parse_string(data, start_char, end_char)
      @last_was_newline = false
      tokens = StringTokenizer.new(data, start_char, end_char).tokenize
      @tokens += tokens
      @column += end_char - start_char
      @last_was_newline = false
    end

    def problem(data, ts, te)
      message = "Unexpected \"#{data[ts...te]}\" on line #{@line}\n" +
            "#{@line}: #{@lines[@line-1]}"
      @data = ""
      @eof = -1
      if @error_handler
        @error_handler.call(message)
      else
        $stderr.puts message
        exit(1)
      end
    end

    def self.tokenize data, filename, &error_handler
      new.tokenize(data, filename, &error_handler)
    end

    def eof
      @eof
    end

    def reset
      @line = 1
      @column = 0
      @tokens = []
      @indents = 0
    end

    def tokenize(data, filename, &error_handler)
      @last_was_newline = false
      @filename = filename
      @data = data
      @current_indents = 0
      @lines = data.lines.to_a
      @error_handler = error_handler if block_given?
      reset
      @eof = data.length
      %% write init;
      %% write exec;
      while @tokens.last && @tokens.last[0] == :NEWLINE
        @tokens.pop
      end
      newline
      if @current_indents > 0
        @current_indents.times do
          @tokens << [:DEDENT,  Token.new("<dedent>", @line)]
          newline
        end
      end
      @tokens
    end
  end
end
