# frozen_string_literal: true

# Copyright (c) 2011-2016 Francesco Rodríguez
# Copyright (c) 2011-2015 Michel Martens
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "hache"

class HMote
  PATTERN = /
    ^[^\S\n]*(%)[^\S\n]*(.*?)(?:\n|\z) |  # % single-line code
    (<\?)\s+(.*?)\s+\?>                |  # <? multi-line code ?>
    (\{\{!?)(.*?)\}\}                     # {{ escape }} or {{! unescape }}
  /mx

  def self.parse(template, context = self, vars = [])
    terms = template.split(PATTERN)
    parts = "Proc.new do |params, __o|\n params ||= {}; __o ||= ''\n".dup

    vars.each { |var| parts << sprintf("%s = params[%p]\n", var, var) }

    while (term = terms.shift)
      parts << parse_expression(terms, term)
    end

    parts << "__o; end"

    compile(context, parts)
  end

  def self.parse_expression(terms, term)
    case term
    when "<?"  then terms.shift + "\n"
    when "%"   then terms.shift + "\n"
    when "{{"  then "__o << Hache.h((" + terms.shift + ").to_s)\n"
    when "{{!" then "__o << (" + terms.shift + ").to_s\n"
    else            "__o << " + term.dump + "\n"
    end
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
