require "benchmark/ips"
require "action_view"
require_relative "../lib/hmote"

def template_path(template)
  File.join(File.expand_path("templates", __dir__), template)
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

MOTE_TEMPLATE = template_path("mote")
ERB_TEMPLATE = template_path("erb")

VIEW_CONTEXT = Context.new
ACTIONVIEW_TEMPLATE = ActionView::Template.new(
  File.read(ERB_TEMPLATE), "template",
  ActionView::Template::Handlers::ERB.new,
  format: :html, virtual_path: "template"
)
ACTIONVIEW_TEMPLATE.locals = [:text]
