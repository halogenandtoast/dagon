require 'rspec'
require 'active_support/core_ext/string/strip'
require 'pry'

def parse(code)
  @results = {}
  lines = code.split("\n")
  lines.each do |line|
    parts = line.split(': ')
    @results[parts[0]] = parts[1].to_i
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
end
