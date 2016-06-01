require_relative "lib/hmote/version"

Gem::Specification.new do |s|
  s.name        = "hmote"
  s.version     = HMote::VERSION
  s.summary     = "A minimum operational template that escapes HTML tags by default"
  s.description = s.summary
  s.author      = "Francesco Rodriguez"
  s.email       = "frodsan@protonmail.com"
  s.homepage    = "https://github.com/frodsan/hmote"
  s.license     = "MIT"

  s.files      = Dir["LICENSE", "README.md", "lib/**/*.rb"]
  s.test_files = Dir["test/**/*.rb"]

  s.add_dependency "hache", "~> 2.0"
  s.add_development_dependency "minitest", "~> 5.8"
  s.add_development_dependency "minitest-sugar", "~> 2.1"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rubocop", "~> 0.39"
end
