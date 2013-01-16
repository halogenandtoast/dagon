task default: [:clean, :build]
task build: "lib/ethos/tokenizer.rb"
task :clean do
  if File.exists? "./lib/ethos/tokenizer.rb"
    `rm lib/ethos/tokenizer.rb`
  end
end
file "lib/ethos/tokenizer.rb" => "lib/ethos/tokenizer.rl" do
  `ragel -R lib/ethos/tokenizer.rl`
end

