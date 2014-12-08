require_relative "helper"

text = %q(some text without escapable characters)

Benchmark.ips do |x|
  x.report("hmote") { HMote.render(MOTE_TEMPLATE, text: text) }
  x.report("rails") { ACTIONVIEW_TEMPLATE.render(VIEW_CONTEXT, text: text) }
end

# Calculating -------------------------------------
#                hmote    28.005k i/100ms
#                rails    10.422k i/100ms
# -------------------------------------------------
#                hmote    361.054k (± 3.5%) i/s -      1.820M
#                rails    112.827k (± 3.1%) i/s -    573.210k
