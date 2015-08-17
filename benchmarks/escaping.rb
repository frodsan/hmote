require_relative "helpers/helper"
require_relative "helpers/hmote_helper"
require_relative "helpers/rails_helper"

text = %q(some < text > inside & these " escapable' characters/1234)

Benchmark.ips do |x|
  x.report("hmote") { hmote(text: text) }
  x.report("rails") { rails(text: text) }
  x.compare!
end
