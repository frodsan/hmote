require_relative "helpers/helper"
require_relative "helpers/hmote_helper"
require "allocation_stats"

def benchmark(text)
  stats = AllocationStats.new(burn: 5).trace do
    hmote(text: text)
  end

  allocations = stats.allocations.all.size
  memsize = stats.allocations.bytes.to_a.inject(&:+)

  puts "total allocations: #{ allocations }"
  puts "total memsize: #{ memsize }"
  puts stats.allocations(alias_paths: true).to_text
end

puts "== Unsafe mode\n"

benchmark(%q(some < text > inside & these " escapable' characters/1234))

puts "\n== Safe mode\n"

benchmark(%q(some text without escapable characters))
