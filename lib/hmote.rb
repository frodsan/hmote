require "hache"

class HMote
  PATTERN = /
    ^(\n)                    |  # newlines.
    ^\s*(%)\s*(.*?)(?:\n|\Z) |  # % single-line code
    (<\?)\s+(.*?)\s+\?>      |  # <? multi-line code ?>
    (\{\{!?)(.*?)\}\}           # {{ escape }} or {{! unescape }}
  /mx

  def self.parse(template, context = self, vars = [])
    terms = template.split(PATTERN)
    parts = "Proc.new do |params, __o|\n params ||= {}; __o ||= ''\n"

    vars.each do |var|
      parts << sprintf("%s = params[%s]\n", var, var.inspect)
    end

    while (term = terms.shift)
      case term
      when "<?"  then parts << "#{terms.shift}\n"
      when "%"   then parts << "#{terms.shift}\n"
      when "{{"  then parts << "__o << Hache.h((#{terms.shift}).to_s)\n"
      when "{{!" then parts << "__o << (#{terms.shift}).to_s\n"
      else            parts << "__o << #{term.dump}\n"
      end
    end

    parts << "__o; end"

    compile(context, parts)
  end

  def self.compile(context, parts)
    context.instance_eval(parts)
  end

  module Helpers
    def hmote(file, params = {}, context = self)
      hmote_cache[file] ||= HMote.parse(File.read(file), context, params.keys)
      hmote_cache[file].call(params)
    end

    def hmote_cache
      Thread.current[:_hmote_cache] ||= {}
    end
  end
end
