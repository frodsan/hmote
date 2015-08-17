require_relative "../hmote"

module HMote::Render
  include HMote::Helpers

  CONTENT_TYPE = "Content-Type".freeze
  DEFAULT_CONTENT_TYPE = "text/html; charset=utf-8".freeze

  def self.setup(app)
    app.settings[:hmote] ||= {}

    app.layout("layout")
    app.view_path("views")
  end

  def render(template, params = {}, layout = settings[:hmote][:layout])
    res.status ||= 200
    res.headers[CONTENT_TYPE] ||= DEFAULT_CONTENT_TYPE
    res.write(view(template, params, layout))

    halt(res.finish)
  end

  def view(template, params = {}, layout = settings[:hmote][:layout])
    return partial(layout, params.merge(content: partial(template, params)))
  end

  def partial(template, params = {})
    return hmote(template_path(template), params.merge(app: self), TOPLEVEL_BINDING)
  end

  def template_path(template)
    return File.join(settings[:hmote][:views], "#{template}.mote")
  end

  module ClassMethods
    def layout(name)
      settings[:hmote][:layout] = name
    end

    def view_path(path)
      settings[:hmote][:views] = File.expand_path(path, Dir.pwd)
    end
  end
end
