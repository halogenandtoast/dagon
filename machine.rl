%%{
  machine new_parser;

  action cmd_err {
    puts "Command error: #{data}"
  }

  action end_program {
    eof = pe
  }

  newvar = '-'? lower ( lower | digit | '-' )*;
  string_character = any - '"';
  string = '"' (string_character | '\"')* '"' ;
  float = digit+ '.' digit+;
  literal = digit | float | string;
  assignment = newvar ":" space literal;
  expression = assignment;
  main := (expression '\n'*)* @end_program $err(cmd_err);
}%%

%% write data;

def parse data
  pe = data.length
  %% write init;
  %% write exec;
end

program =  DATA.read
parse program
__END__
x: 5
y: 6
dshfjkdsfkjhkj
