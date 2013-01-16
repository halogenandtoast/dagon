$line = 0
$column = 0
$tokens = []
%%{
  machine new_parser;
  identifier = '-'? lower (lower | digit | '-')*;
  assignment = ':';
  float = digit+ '.' digit+;
  literal = digit;
  newline = "\r"? "\n" | "\r";
  string = "\"" (any - "\"")* "\"";

  main := |*
    identifier => { emit(:variable, data, ts, te) };
    assignment => { emit(:assignment, data, ts, te) };
    float => { emit(:float, data, ts, te) };
    literal => { emit(:literal, data, ts, te) };
    string => { emit(:string, data, ts, te) };
    newline { $line += 1; $column = 0 };
    space => { emit(:space, data, ts, te) };
    any => { problem(data, ts, te) };
  *|;
}%%

%% write data;

def emit(name, data, start_char, end_char)
  $tokens << [[$line, $column], name, data[start_char...end_char]]
  $column += end_char - start_char
end

def problem(data, ts, te)
  puts $tokens.inspect
  raise "Oops {#{data[ts...-1]}}"
end

def tokenize(data)
  eof = data.length
  %% write init;
  %% write exec;
end

program = DATA.read
tokenize program
puts $tokens.inspect

__END__
float: 1.0
one: 1
two: 2
five: 5
string: "stringy"
