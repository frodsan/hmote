require_relative "../hmote"

module HMote::Render
  include HMote::Helpers

  def self.setup(app)
    app.settings[:hmote] ||= {}
    app.settings[:hmote][:views] ||= File.expand_path("views", Dir.pwd)
    app.settings[:hmote][:layout] ||= "layout"
  end

  def render(template, params = {}, layout = settings[:hmote][:layout])
    res.headers["Content-Type"] ||= "text/html; charset=utf-8"
    res.write(view(template, params, layout))
  end

  def view(template, params = {}, layout = settings[:hmote][:layout])
    return partial(layout, params.merge(content: partial(template, params)))
  end

  def partial(template, params = {})
    return hmote(template_path(template), params.merge(app: self), TOPLEVEL_BINDING)
  end

  def template_path(template)
    if template.end_with?(".mote")
      return template
    else
      return File.join(settings[:hmote][:views], "#{template}.mote")
    end
  end
end
