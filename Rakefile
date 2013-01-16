task default: [:clean, :build]
task build: "lib/dagon/tokenizer.rb"
task :clean do
  if File.exists? "./lib/dagon/tokenizer.rb"
    `rm lib/dagon/tokenizer.rb`
  end
end
file "lib/dagon/tokenizer.rb" => "lib/dagon/tokenizer.rl" do
  `ragel -R lib/dagon/tokenizer.rl`
end

