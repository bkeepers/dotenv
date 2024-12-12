require "bundler/setup"
require "dotenv"
require "benchmark/ips"
require "tempfile"

f = Tempfile.create("benchmark_ips.env")
1000.times.map { |i| f.puts "VAR_#{i}=#{i}" }
f.close

Benchmark.ips do |x|
  x.report("parse, overwrite:false") { Dotenv.parse(f.path, overwrite: false) }
  x.report("parse, overwrite:true") { Dotenv.parse(f.path, overwrite: true) }
end

File.unlink(f.path)
