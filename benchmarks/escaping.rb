require_relative "helper"

text = %q(some < text > inside & these " escapable' characters/1234)

Benchmark.ips do |x|
  x.report("hmote") { HMote.render(MOTE_TEMPLATE, text: text) }
  x.report("rails") { ACTIONVIEW_TEMPLATE.render(VIEW_CONTEXT, text: text) }
end

# Calculating -------------------------------------
#                hmote    12.015k i/100ms
#                rails     7.599k i/100ms
# -------------------------------------------------
#                hmote    144.502k (± 3.3%) i/s -    732.915k
#                rails     87.077k (± 3.3%) i/s -    440.742k
