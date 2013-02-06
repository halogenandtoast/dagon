module Dagon
  class StringTokenizer
    def initialize data, start_char, end_char
      @data = data
      @start_char = start_char
      @end_char = end_char
      @tokens = []
      @dstr = false
    end

    def tokenize
      if quote == '"'
        parse_double_quoted_string
      else
        @tokens << [:STRING, Token.new(string, @line)]
      end
    end

    def parse_double_quoted_string
      io = StringIO.new(string)
      actual_string = ""
      while current_char = io.getc
        if current_char == "\\"
          value = parse_escape(io)
          actual_string << value
        elsif current_char == '#'
          next_char = io.getc
          if next_char == '{'
            if dstr
              @tokens << [:STRING, Token.new(actual_string, @line)]
            else
              dstr = true
              @tokens << [:DSTRING_BEGIN, Token.new('"', @line)]
              @tokens << [:STRING, Token.new(actual_string, @line)]
            end
            actual_string = ""
            program = ""
            while (program_char = io.getc) && program_char != '}'
              program << program_char
            end
            @tokens += Scanner.tokenize(program, '(streval)')
          else
            io.ungetc(next_char)
            actual_string << current_char
          end
        else
          actual_string << current_char
        end
      end
      if dstr
        if actual_string.length > 0
          @tokens << [:STRING, Token.new(actual_string, @line)]
        end
        @tokens << [:DSTRING_END, Token.new('"', @line)]
      else
        @tokens << [:STRING, Token.new(actual_string, @line)]
      end
      @tokens
    end

    def parse_escape(io)
      c = io.getc
      case c
      when 'n' then "\n"
      when 't' then "\t"
      when 'r' then "\r"
      when 'f' then "\f"
      when 'v' then "\13"
      when 'a' then "\007"
      when 'e' then "\033"
      when '0'..'7'
        io.ungetc(c)
        parse_octal(io, 3).chr
      else
        io.ungetc(c)
        "\\"
      end
    end

    def parse_octal(io, len)
      c = io.getc
      return_value = 0
      while c && len > 0 && c >= '0' && c <= '7'
        return_value <<= 3
        return_value |= c - ?0
        len -= 1
        c = io.getc
      end
      io.ungetc(c)
      return_value
    end

    private

    attr_reader :data, :start_char, :end_char, :dstr

    def quote
      @_quote ||= data[start_char]
    end

    def string
      @_string ||= data[(start_char+1)...(end_char-1)]
    end

  end
end
