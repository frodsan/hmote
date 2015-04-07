hmote
=====

Minimal template engine with default escaping.

Description
-----------

HMote is a fork of [Mote][mote] that uses [Hache][hache]
to auto-escape HTML special characters.

Basic Usage
-----------

This is a basic example:

```ruby
require "hmote"

template = HMote.parse("your template goes here!")
template.call
# => "your template goes here!"
```

HMote recognizes three tags to evaluate Ruby code: `%`, `{{}}` and `<? ?>`.
The difference between them is that while the `%` and `<? ?>` tags only
evaluate the code, the `{{}}` tag also prints the result to the template.

Imagine that your template looks like this:

```ruby
% # single-line code
% gems = ["rack", "cuba", "hmote"]

<?
  # multi-line code
  sorted = gems.sort
?>

<ul>
% sorted.each do |gem|
  <li>{{ gem }}</li>
% end
</ul>
```

The generated result will be:

```html
<ul>
  <li>cuba</li>
  <li>hmote</li>
  <li>rack</li>
</ul>
```

Parameters
----------

The values passed to the template are available as local variables:

```ruby
template = HMote.parse("Hello {{ name }}", self, [:name])
template.call(name: "Ruby")
# => Hello Ruby
```

You can also use the `params` local variable to access the given
parameters:

```ruby
template = HMote.parse("Hello {{ params[:name] }}", self)
template.call(name: "Ruby")
# => Hello Ruby
```

Auto-escaping
-------------

By default, HMote escapes HTML special characters to prevent [XSS][xss]
attacks. You can start the expression with an exclamation mark to disable
escaping for that expression:

```ruby
template = HMote.parse("Hello {{ name }}", self, [:name])
template.call(name: "<b>World</b>")
# => Hello &lt;b&gt;World&lt;b&gt;

template = HMote.parse("Hello {{! name }}", self, [:name])
template.call(name: "<b>World</b>")
# => Hello <b>World</b>
```

HMote::Helpers
--------------

There's a helper available in the `HMote::Helpers` module, and you are
free to include it in your code. To do it, just type:

```ruby
include HMote::Helpers
```

### Using the hmote helper

The `hmote` helper receives a file name and a hash and returns the rendered
version of its content. The compiled template is cached for subsequent calls.

```ruby
hmote("test/basic.mote", n: 3)
# => "***\n"
```

### Template caching

When the `hmote` helper is first called with a template name, the
file is read and parsed, and a proc is created and stored in the
current thread. The parameters passed are defined as local variables
in the template. If you want to provide more parameters once the template
was cached, you won't be able to access the values as local variables,
but you can always access the `params` hash.

For example:

```ruby
# First call
hmote("foo.mote", a: 1, b: 2)
```

HMote::Render
-------------

To use HMote in [Cuba][cuba], you need to load the `HMote::Render`
plugin as shown below:

```ruby
require "hmote"
require "hmote/render"

Cuba.plugin(HMote::Render)
```

`HMote::Render` provides three helper methods for rendering templates:
`partial`, `view` and `render`.

```ruby
Cuba.define do
  on "about" do
    # `partial` renders a template without a layout.
    res.write partial("about")
  end

  on "home" do
    # `view` renders a template within a layout.
    res.write view("about")
  end

  on "contact" do
    # `render` is a shortcut to `res.write view(...)`
    render("contact")
  end
end
```

By default, `HMote::Render` assumes that all view templates are placed
in a folder named `views` and that they use the `.mote` extension. Also
for `view` and `render` methods, it assumes that the layout template is
called `layout.mote`.

The defaults can be changed through the `Cuba.settings` method:

```ruby
Cuba.settings[:hmote][:views] = "./views/admin/"
Cuba.settings[:hmote][:layout] = "admin"
```

### Layouts

To render inner content into a layout, use the `{{! content }}` tag.

```html
<html>
  <head>
    <title>Mote Layout</title>
  </head>
  <body>
    <h1>Hello, world!</h1>

    {{! content }}
  </body>
</html>
```

### Helpers

You can use the `app` variable to access the application helpers.

```ruby
Cuba.define do
  def h(unsafe)
    ...
  end
end
```

```html
<h1>{{! app.h("unsafe") }}</h1>

{{ app.partial("list") }}
```

Installation
------------

```
$ gem install hmote
```

[cuba]: http://cuba.is
[mote]: https://github.com/soveran/mote
[hache]: https://github.com/frodsan/hache
[xss]: http://en.wikipedia.org/wiki/Cross-Site_Scripting
