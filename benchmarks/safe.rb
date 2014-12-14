require_relative "helper"
require_relative "hmote_helper"
require_relative "rails_helper"

text = %q(some text without escapable characters).html_safe

Benchmark.ips do |x|
  x.report("hmote") { hmote(text: text) }
  x.report("rails") { rails(text: text) }
end

# Calculating -------------------------------------
#                hmote    29.035k i/100ms
#                rails    14.607k i/100ms
# -------------------------------------------------
#                hmote    367.044k (± 5.9%) i/s -      1.829M
#                rails    157.936k (± 5.9%) i/s -    788.778k
