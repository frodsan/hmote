require "bundler/setup"
require "action_view"
require "allocation_stats"
require "benchmark/ips"
require_relative "../lib/hmote"

def benchmark(&block)
  Benchmark.ips(&block)
end

def memory(desc, burn: 5, trace: false)
  stats = AllocationStats.new(burn: burn).trace { yield }

  allocations = stats.allocations.all.size
  memsize = stats.allocations.bytes.to_a.inject(&:+)

  puts("#{ desc } : #{ allocations } allocations - #{ memsize } memsize")
  puts(stats.allocations(alias_paths: true).to_text) if ENV["TRACE"]
end

include HMote::Helpers

MOTE_TEMPLATE = File.join(File.expand_path("templates", __dir__), "mote")

def __hmote(params)
  hmote(MOTE_TEMPLATE, params)
end

class Context
  class LookupContext
    def disable_cache
      yield
    end

    def find_template(*args)
    end
  end

  def lookup_context
    @lookup_context ||= LookupContext.new
  end
end

ERB_TEMPLATE = File.join(File.expand_path("templates", __dir__), "erb")

ACTIONVIEW_CONTEXT = Context.new
ACTIONVIEW_TEMPLATE = ActionView::Template.new(
  File.read(ERB_TEMPLATE), "template",
  ActionView::Template::Handlers::ERB.new,
  format: :html, virtual_path: "template"
)

ACTIONVIEW_TEMPLATE.locals = [:text]

def __rails(params)
  ACTIONVIEW_TEMPLATE.render(ACTIONVIEW_CONTEXT, params)
end
