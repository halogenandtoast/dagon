require 'rspec'
require 'active_support/core_ext/string/strip'

module New
  class Parser
    STRING_REGEXP = /(?<quote>"|')(?<string>.*)\k<quote>/
      attr_accessor :results

    def initialize(code)
      self.code = code
    end

    def parse
      self.results = {}
      lines = code.split("\n")
      lines.each do |line|
        parts = line.split(': ')
        if string = STRING_REGEXP.match(parts[1]).try(:[], 'string')
          result = string
        elsif parts[1] =~ /\d+\.\d+/
          result = Float(parts[1])
        else
          result = Integer(parts[1])
        end

        self.results[parts[0]] = result
      end
      self
    end

    private

    attr_accessor :code
  end

  describe New do
    it 'can assign a variable' do
      new = parse(%{x: 1})

      expect(new.results["x"]).to be_a(Integer)
      expect(new.results["x"]).to eq(1)
    end

    it 'can assign another variable' do
      new = parse(<<-CODE.strip_heredoc)
        x: 1
        y: 2
      CODE

      expect(new.results["x"]).to eq(1)
      expect(new.results["y"]).to eq(2)
    end

    it 'maybe knows floats' do
      new = parse("x: 1.0")

      expect(new.results["x"]).to eq(1.0)
      expect(new.results["x"]).to be_a(Float)
    end

    it 'can assign a string even' do
      new = parse(%{x: "stringy"})

      expect(new.results["x"]).to eq("stringy")
    end

    it "can has '' string syntax too" do
      new = parse(%{x: 'stringy'})

      expect(new.results["x"]).to eq("stringy")
    end

    it "doesn't work with mismatched quote types" do
      expect { parse(%{x: "stringy'}) }.to raise_error(ArgumentError)
    end

    def parse(code)
      Parser.new(code).parse
    end
  end
end
