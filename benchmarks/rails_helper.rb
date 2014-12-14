require "action_view"

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

ACTIONVIEW_CONTEXT = Context.new
ACTIONVIEW_TEMPLATE = ActionView::Template.new(
  File.read(ERB_TEMPLATE), "template",
  ActionView::Template::Handlers::ERB.new,
  format: :html, virtual_path: "template"
)
ACTIONVIEW_TEMPLATE.locals = [:text]

def rails(params)
  ACTIONVIEW_TEMPLATE.render(ACTIONVIEW_CONTEXT, params)
end
