require_relative "lib/hmote/version"

Gem::Specification.new do |s|
  s.name        = "hmote"
  s.version     = HMote::VERSION
  s.summary     = "A minimum operational template that escapes HTML tags by default."
  s.description = s.summary + " Inspired by mote."
  s.authors     = ["Francesco Rodríguez", "Mayn Kjær"]
  s.email       = ["frodsan@protonmail.ch", "mayn.kjaer@gmail.com"]
  s.homepage    = "https://github.com/harmoni/hmote"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "hache", "~> 1.1"
  s.add_development_dependency "cutest", "~> 1.2"
end
