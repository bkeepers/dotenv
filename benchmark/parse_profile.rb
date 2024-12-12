require "bundler/setup"
require "dotenv"
require "stackprof"
require "benchmark/ips"
require "tempfile"

f = Tempfile.create("benchmark_ips.env")
1000.times.map { |i| f.puts "VAR_#{i}=#{i}" }
f.close

profile = StackProf.run(mode: :wall, interval: 1_000) do
  10_000.times do
    Dotenv.parse(f.path, overwrite: false)
  end
end

result = StackProf::Report.new(profile)
puts
result.print_text
puts "\n\n\n"
result.print_method(/Dotenv.parse/)

File.unlink(f.path)
