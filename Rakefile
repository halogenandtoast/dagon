desc "Build freshly"
task default: [:clean, :build]

namespace :build do
  desc "Build tokenizer"
  task tokenizer: "lib/dagon/tokenizer.rb"

  desc "Build AST generator"
  task ast_generator: "build/ast/generator.rb"
end
desc "Build tokenizer and AST generator"
task build: %w{build:tokenizer build:ast_generator}

desc "Remove generated files"
task :clean do
  ["./lib/dagon/tokenizer.rb", "build/ast/generator.rb"].each do |file|
    if File.exists? file
      `rm #{file}`
    end
  end
end

file "build/ast/generator.rb" => "lib/dagon/ast/generator.y" do
  `racc -o build/ast/generator.rb lib/dagon/ast/generator.y`
end
file "lib/dagon/tokenizer.rb" => "lib/dagon/tokenizer.rl" do
  `ragel -R lib/dagon/tokenizer.rl`
end

namespace :test do
  task ast_generator: "build:ast_generator" do
    puts `rspec spec/ast/generator_spec.rb`
  end
end
task test: "test:ast_generator"
