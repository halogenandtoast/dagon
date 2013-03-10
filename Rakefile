desc "Build freshly"
task default: [:clean, :build, :test]

namespace :build do
  desc "Build scanner"
  task scanner: "build/scanner.rb"

  desc "Build parser"
  task parser: "build/parser.rb"

  namespace :debug do
    task :parser do
      `racc -g -v -O build/parser.output -o build/parser.rb dagon/parser.y`
    end
  end
end

desc "Build scanner and parser"
task build: %w{build:scanner build:parser}
task debug: %w{build:scanner build:debug:parser}

desc "Remove generated files"
task :clean do
  if File.exists?('build/')
    `rm -r build`
  end
end

file "build/parser.rb" => "dagon/parser.y" do
  puts "Building parser"
  `mkdir -p build/`
  `racc -g -o build/parser.rb dagon/parser.y`
end
file "build/scanner.rb" => "dagon/scanner.rl" do
  puts "Building scanner"
  `mkdir -p build/`
  `ragel -R dagon/scanner.rl -o build/scanner.rb`
end

task :test do
  puts "Running tests..."
  system('dspec')
end
