task default: :clean do
  `ragel -R machine.rl`
  puts `ruby machine.rb`
end

task :clean do
  `rm machine.rb`
end
