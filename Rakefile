desc "Build freshly"
task default: [:clean, :build]

namespace :build do
  desc "Build tokenizer"
  task tokenizer: "lib/dagon/tokenizer.rb"

  desc "Build AST generator"
  task ast_generator: "lib/dagon/ast/generator.rb"
end
desc "Build tokenizer and AST generator"
task build: [:tokenizer, :ast_generator]

desc "Remove generated files"
task :clean do
  ["./lib/dagon/tokenizer.rb", "./lib/dagon/ast/generator.rb"].each do |file|
    if File.exists? file
      `rm #{file}`
    end
  end
end

file "lib/dagon/ast/generator.rb" => "lib/dagon/ast/generator.y" do
  `racc -o lib/dagon/ast/generator.rb lib/dagon/ast/generator.y`
end
file "lib/dagon/tokenizer.rb" => "lib/dagon/tokenizer.rl" do
  `ragel -R lib/dagon/tokenizer.rl`
end

namespace :test do
  task ast_generator: "build:ast_generator" do
    puts `rspec lib/dagon/ast/generator.rb`
  end
end
task test: "test:ast_generator"
