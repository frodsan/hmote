Gem::Specification.new do |s|
  s.name        = "hmote"
  s.version     = "1.1.0"
  s.summary     = "A minimum operational template that escapes HTML tags by default."
  s.description = s.summary
  s.authors = ["Francesco Rodríguez", "Mayn Kjær"]
  s.email = ["frodsan@me.com", "mayn.kjaer@gmail.com"]
  s.homepage    = "https://github.com/harmoni-io/hmote"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "hache"
  s.add_development_dependency "cutest"
end
