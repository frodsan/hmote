require "bundler/setup"
require "benchmark/ips"

def template_path(template)
  File.join(File.expand_path("../templates", __dir__), template)
end

MOTE_TEMPLATE = template_path("mote")
ERB_TEMPLATE  = template_path("erb")
