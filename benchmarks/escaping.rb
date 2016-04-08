# frozen_string_literal: true

require_relative "helper"

text = %q(some < text > inside & these " escapable' characters/1234)

benchmark do |x|
  x.report("hmote") { __hmote(text: text) }
  x.report("rails") { __rails(text: text) }
  x.compare!
end

# Calculating -------------------------------------
#                hmote    12.051k i/100ms
#                rails     8.502k i/100ms
# -------------------------------------------------
#                hmote    141.795k (± 4.7%) i/s -    711.009k
#                rails     92.098k (± 4.2%) i/s -    467.610k
#
# Comparison:
#                hmote:   141794.6 i/s
#                rails:    92098.2 i/s - 1.54x slower

memory { __rails(text: text) }
# {:allocations=>19, :memsize=>2053}

memory { __hmote(text: text) }
# {:allocations=>13, :memsize=>1414}
