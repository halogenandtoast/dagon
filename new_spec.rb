require 'rspec'
require 'active_support/core_ext/string/strip'
require 'pry'

def parse(code)
  @results = {}
  lines = code.split("\n")
  lines.each do |line|
    parts = line.split(': ')
    string_regexp = /(?<quote>"|')(?<string>.*)\k<quote>/
    if r = string_regexp.match(parts[1])
      result = r['string']
    else
      result = Integer(parts[1])
    end

    @results[parts[0]] = result
  end
end

describe "it" do
  it 'can assign a variable' do
    parse(<<-CODE.strip_heredoc)
      x: 1
    CODE

    expect(@results["x"]).to eq(1)
  end

  it 'can assign another variable' do
    parse(<<-CODE.strip_heredoc)
      x: 1
      y: 2
    CODE

    expect(@results["x"]).to eq(1)
    expect(@results["y"]).to eq(2)
  end

  it 'can assign a string even' do
    parse(<<-CODE.strip_heredoc)
      x: "stringy"
    CODE

    expect(@results["x"]).to eq("stringy")
  end

  it "can has '' string syntax too" do
    parse(<<-CODE.strip_heredoc)
      x: 'stringy'
    CODE

    expect(@results["x"]).to eq("stringy")
  end

  it "doesn't work with mismatched quote types" do
    expect { parse(%{x: "stringy'}) }.to raise_error(ArgumentError)
  end
end
