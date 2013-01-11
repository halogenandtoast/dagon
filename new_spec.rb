require 'rspec'
require 'active_support/core_ext/string/strip'
require 'pry'

class New
  attr_accessor :results

  def initialize(code)
    self.code = code
  end

  def parse
    self.results = {}
    lines = code.split("\n")
    lines.each do |line|
      parts = line.split(': ')
      string_regexp = /(?<quote>"|')(?<string>.*)\k<quote>/
      if r = string_regexp.match(parts[1])
        result = r['string']
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
    new = New.new(%{x: 1}).parse

    expect(new.results["x"]).to eq(1)
  end

  it 'can assign another variable' do
    new = New.new(<<-CODE.strip_heredoc).parse
      x: 1
      y: 2
    CODE

    expect(new.results["x"]).to eq(1)
    expect(new.results["y"]).to eq(2)
  end

  it 'can assign a string even' do
    new = New.new(%{x: "stringy"}).parse

    expect(new.results["x"]).to eq("stringy")
  end

  it "can has '' string syntax too" do
    new = New.new(%{x: 'stringy'}).parse

    expect(new.results["x"]).to eq("stringy")
  end

  it "doesn't work with mismatched quote types" do
    expect { New.new(%{x: "stringy'}).parse }.to raise_error(ArgumentError)
  end
end
