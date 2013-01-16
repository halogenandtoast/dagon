
# line 1 "lib/dagon/tokenizer.rl"
$line = 0
$column = 0
$tokens = []

# line 23 "lib/dagon/tokenizer.rl"



# line 12 "lib/dagon/tokenizer.rb"
class << self
	attr_accessor :_new_parser_actions
	private :_new_parser_actions, :_new_parser_actions=
end
self._new_parser_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6, 1, 
	7, 1, 8, 1, 9, 1, 10, 1, 
	11, 1, 12, 1, 13, 1, 14
]

class << self
	attr_accessor :_new_parser_key_offsets
	private :_new_parser_key_offsets, :_new_parser_key_offsets=
end
self._new_parser_key_offsets = [
	0, 1, 3, 6, 18, 19, 20, 22, 
	27, 30
]

class << self
	attr_accessor :_new_parser_trans_keys
	private :_new_parser_trans_keys, :_new_parser_trans_keys=
end
self._new_parser_trans_keys = [
	34, 48, 57, 46, 48, 57, 10, 13, 
	32, 34, 45, 58, 9, 12, 48, 57, 
	97, 122, 10, 34, 97, 122, 45, 48, 
	57, 97, 122, 46, 48, 57, 48, 57, 
	0
]

class << self
	attr_accessor :_new_parser_single_lengths
	private :_new_parser_single_lengths, :_new_parser_single_lengths=
end
self._new_parser_single_lengths = [
	1, 0, 1, 6, 1, 1, 0, 1, 
	1, 0
]

class << self
	attr_accessor :_new_parser_range_lengths
	private :_new_parser_range_lengths, :_new_parser_range_lengths=
end
self._new_parser_range_lengths = [
	0, 1, 1, 3, 0, 0, 1, 2, 
	1, 1
]

class << self
	attr_accessor :_new_parser_index_offsets
	private :_new_parser_index_offsets, :_new_parser_index_offsets=
end
self._new_parser_index_offsets = [
	0, 2, 4, 7, 17, 19, 21, 23, 
	27, 30
]

class << self
	attr_accessor :_new_parser_trans_targs
	private :_new_parser_trans_targs, :_new_parser_trans_targs=
end
self._new_parser_trans_targs = [
	3, 0, 9, 3, 1, 2, 3, 3, 
	4, 3, 5, 6, 3, 3, 8, 7, 
	3, 3, 3, 3, 0, 7, 3, 7, 
	7, 7, 3, 1, 2, 3, 9, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 0
]

class << self
	attr_accessor :_new_parser_trans_actions
	private :_new_parser_trans_actions, :_new_parser_trans_actions=
end
self._new_parser_trans_actions = [
	9, 0, 0, 27, 0, 0, 27, 11, 
	0, 13, 5, 0, 7, 13, 5, 0, 
	15, 11, 23, 9, 0, 0, 25, 0, 
	0, 0, 17, 0, 0, 21, 0, 19, 
	29, 27, 27, 23, 25, 25, 17, 21, 
	19, 0
]

class << self
	attr_accessor :_new_parser_to_state_actions
	private :_new_parser_to_state_actions, :_new_parser_to_state_actions=
end
self._new_parser_to_state_actions = [
	0, 0, 0, 1, 0, 0, 0, 0, 
	0, 0
]

class << self
	attr_accessor :_new_parser_from_state_actions
	private :_new_parser_from_state_actions, :_new_parser_from_state_actions=
end
self._new_parser_from_state_actions = [
	0, 0, 0, 3, 0, 0, 0, 0, 
	0, 0
]

class << self
	attr_accessor :_new_parser_eof_trans
	private :_new_parser_eof_trans, :_new_parser_eof_trans=
end
self._new_parser_eof_trans = [
	33, 35, 35, 0, 36, 38, 38, 39, 
	40, 41
]

class << self
	attr_accessor :new_parser_start
end
self.new_parser_start = 3;
class << self
	attr_accessor :new_parser_first_final
end
self.new_parser_first_final = 3;
class << self
	attr_accessor :new_parser_error
end
self.new_parser_error = -1;

class << self
	attr_accessor :new_parser_en_main
end
self.new_parser_en_main = 3;


# line 26 "lib/dagon/tokenizer.rl"

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
  
# line 159 "lib/dagon/tokenizer.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = new_parser_start
	ts = nil
	te = nil
	act = 0
end

# line 40 "lib/dagon/tokenizer.rl"
  
# line 171 "lib/dagon/tokenizer.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	end
	if _goto_level <= _resume
	_acts = _new_parser_from_state_actions[cs]
	_nacts = _new_parser_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _new_parser_actions[_acts - 1]
			when 1 then
# line 1 "NONE"
		begin
ts = p
		end
# line 201 "lib/dagon/tokenizer.rb"
		end # from state action switch
	end
	if _trigger_goto
		next
	end
	_keys = _new_parser_key_offsets[cs]
	_trans = _new_parser_index_offsets[cs]
	_klen = _new_parser_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _new_parser_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _new_parser_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _new_parser_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _new_parser_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _new_parser_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	end
	if _goto_level <= _eof_trans
	cs = _new_parser_trans_targs[_trans]
	if _new_parser_trans_actions[_trans] != 0
		_acts = _new_parser_trans_actions[_trans]
		_nacts = _new_parser_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _new_parser_actions[_acts - 1]
when 2 then
# line 1 "NONE"
		begin
te = p+1
		end
when 3 then
# line 15 "lib/dagon/tokenizer.rl"
		begin
te = p+1
 begin  emit(:assignment, data, ts, te)  end
		end
when 4 then
# line 18 "lib/dagon/tokenizer.rl"
		begin
te = p+1
 begin  emit(:string, data, ts, te)  end
		end
when 5 then
# line 19 "lib/dagon/tokenizer.rl"
		begin
te = p+1
 begin  $line += 1; $column = 0  end
		end
when 6 then
# line 20 "lib/dagon/tokenizer.rl"
		begin
te = p+1
 begin  emit(:space, data, ts, te)  end
		end
when 7 then
# line 21 "lib/dagon/tokenizer.rl"
		begin
te = p+1
 begin  problem(data, ts, te)  end
		end
when 8 then
# line 14 "lib/dagon/tokenizer.rl"
		begin
te = p
p = p - 1; begin  emit(:variable, data, ts, te)  end
		end
when 9 then
# line 16 "lib/dagon/tokenizer.rl"
		begin
te = p
p = p - 1; begin  emit(:float, data, ts, te)  end
		end
when 10 then
# line 17 "lib/dagon/tokenizer.rl"
		begin
te = p
p = p - 1; begin  emit(:literal, data, ts, te)  end
		end
when 11 then
# line 19 "lib/dagon/tokenizer.rl"
		begin
te = p
p = p - 1; begin  $line += 1; $column = 0  end
		end
when 12 then
# line 21 "lib/dagon/tokenizer.rl"
		begin
te = p
p = p - 1; begin  problem(data, ts, te)  end
		end
when 13 then
# line 17 "lib/dagon/tokenizer.rl"
		begin
 begin p = ((te))-1; end
 begin  emit(:literal, data, ts, te)  end
		end
when 14 then
# line 21 "lib/dagon/tokenizer.rl"
		begin
 begin p = ((te))-1; end
 begin  problem(data, ts, te)  end
		end
# line 344 "lib/dagon/tokenizer.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	_acts = _new_parser_to_state_actions[cs]
	_nacts = _new_parser_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _new_parser_actions[_acts - 1]
when 0 then
# line 1 "NONE"
		begin
ts = nil;		end
# line 364 "lib/dagon/tokenizer.rb"
		end # to state action switch
	end
	if _trigger_goto
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	if _new_parser_eof_trans[cs] > 0
		_trans = _new_parser_eof_trans[cs] - 1;
		_goto_level = _eof_trans
		next;
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 41 "lib/dagon/tokenizer.rl"
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
