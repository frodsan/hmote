require_relative "helper"

safe = %q(some text without escapable characters).html_safe

memory("rails safe") { __rails(text: safe) } # => 11 allocations - 1078 memsize
memory("hmote safe") { __hmote(text: safe) } # => 6 allocations - 479 memsize

unsafe = %q(some < text > inside & these " escapable' characters/1234)

memory("rails unsafe") { __rails(text: unsafe) } # => 19 allocations - 2053 memsize
memory("hmote unsafe") { __hmote(text: unsafe) } # => 13 allocations - 1414 memsize
