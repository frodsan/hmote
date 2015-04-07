require_relative "helpers/helper"
require_relative "helpers/hmote_helper"
require_relative "helpers/rails_helper"

text = %q(some < text > inside & these " escapable' characters/1234)

Benchmark.ips do |x|
  x.report("hmote") { hmote(text: text) }
  x.report("rails") { rails(text: text) }
  x.compare!
end

# Calculating -------------------------------------
#                hmote    11.864k i/100ms
#                rails     7.130k i/100ms
# -------------------------------------------------
#                hmote     94.068k (±20.3%) i/s -    450.832k
#                rails     63.242k (±14.5%) i/s -    313.720k
#
# Comparison:
#                hmote:    94067.6 i/s
#                rails:    63242.0 i/s - 1.49x slower
