$line = 0
$column = 0
$tokens = []

=begin
%%{
  machine new_parser;
  identifier = lower (lower | digit | '-')*;
  assignment = ':';
  operator = '+';
  lparen = '(';
  rparen = ')';
  float = digit+ '.' digit+;
  integer = digit+;
  newline = "\r"? "\n" | "\r";
  string = "\"" (any - "\"")* "\"";

  main := |*
    identifier => { emit(:IDENTIFIER, data, ts, te) };
    assignment => { emit(':', data, ts, te) };
    float => { emit(:FLOAT, data, ts, te) };
    integer => { emit(:INTEGER, data, ts, te) };
    string => { emit(:STRING, data, ts, te) };
    newline { $line += 1; $column = 0; emit(:NEWLINE, data, ts, te) };
    space => { emit(' ', data, ts, te) };
    lparen => { emit(:LPAREN, data, ts, te) };
    rparen => { emit(:RPAREN, data, ts, te) };
    operator => { emit(data[ts...te], data, ts, te) };

    any => { problem(data, ts, te) };
  *|;
}%%
=end

module Dagon
  class Tokenizer
    %% write data;
    # % fix syntax highlighting

    def self.emit(name, data, start_char, end_char)
      $tokens << [name, data[start_char...end_char]]
      $column += end_char - start_char
    end

    def self.problem(data, ts, te)
      puts $tokens.inspect
      raise "Oops {#{data[ts...-1]}}"
    end

    def tokenize data
      self.class.tokenize(data)
    end

    def self.tokenize(data)
      eof = data.length
      %% write init;
      %% write exec;
      $tokens
    end
  end
end
