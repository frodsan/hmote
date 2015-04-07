require_relative "helpers/helper"
require_relative "helpers/hmote_helper"
require_relative "helpers/rails_helper"

text = %q(some text without escapable characters).html_safe

Benchmark.ips do |x|
  x.report("hmote") { hmote(text: text) }
  x.report("rails") { rails(text: text) }
  x.compare!
end

# Calculating -------------------------------------
#                hmote    19.972k i/100ms
#                rails     9.820k i/100ms
# -------------------------------------------------
#                hmote    247.489k (± 8.1%) i/s -      1.238M
#                rails    112.561k (± 6.7%) i/s -    569.560k
#
# Comparison:
#                hmote:   247488.5 i/s
#                rails:   112561.5 i/s - 2.20x slower
