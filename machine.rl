$line = 0
$column = 0
$tokens = []
%%{
  machine new_parser;
  new_variable = '-'? lower (lower | digit | '-')*;
  assignment = ':';
  float = digit+ '.' digit+;
  literal = digit;
  newline = "\r"? "\n" | "\r";

  main := |*
    new_variable => { emit(:variable, data, ts, te) };
    assignment => { emit(:assignment, data, ts, te) };
    float => { emit(:float, data, ts, te) };
    literal => { emit(:literal, data, ts, te) };
    newline => { $line += 1; $column = 0 };
    space { emit(:space, data, ts, te) };
  *|;
}%%

%% write data;

def emit(name, data, ts, te)
  $tokens << [[$line, $column], name, data[ts...te]]
  $column += te - ts
end

def tokenize data
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
