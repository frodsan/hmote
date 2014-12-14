require_relative "helper"
require_relative "hmote_helper"
require_relative "rails_helper"

text = %q(some < text > inside & these " escapable' characters/1234)

Benchmark.ips do |x|
  x.report("hmote") { hmote(text: text) }
  x.report("rails") { rails(text: text) }
end

# Calculating -------------------------------------
#                hmote    13.122k i/100ms
#                rails     7.907k i/100ms
# -------------------------------------------------
#                hmote    148.020k (± 3.6%) i/s -    747.954k
#                rails     88.623k (± 2.7%) i/s -    442.792k
