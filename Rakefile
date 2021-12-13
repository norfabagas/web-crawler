task default: %w[run]

task :run do
  ARGV.each { |a| task a.to_sym do; end }

  ruby "lib/run.rb #{ARGV[1]} #{ARGV[2]}"
end

task :result do
  ruby "lib/result.rb"
end