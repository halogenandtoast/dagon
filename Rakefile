desc "Build freshly"
task default: [:clean, :build]

namespace :build do
  desc "Build tokenizer"
  task tokenizer: "build/tokenizer.rb"

  desc "Build AST generator"
  task ast_generator: "build/ast/generator.rb"
end

desc "Build tokenizer and AST generator"
task build: %w{build:tokenizer build:ast_generator}

desc "Remove generated files"
task :clean do
  if File.exists?('build/')
    `rm -r build`
  end
end

file "build/ast/generator.rb" => "lib/dagon/ast/generator.y" do
  `mkdir -p build/ast/`
  `racc -g -o build/ast/generator.rb lib/dagon/ast/generator.y`
end
file "build/tokenizer.rb" => "lib/dagon/tokenizer.rl" do
  `mkdir -p build/`
  `ragel -R lib/dagon/tokenizer.rl -o build/tokenizer.rb`
end

namespace :test do
  task ast_generator: "build:ast_generator" do
    puts `rspec`
  end
end
task test: %w{default test:ast_generator}
