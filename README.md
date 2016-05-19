HMote [![Build Status](https://travis-ci.org/frodsan/hmote.svg)](https://travis-ci.org/frodsan/hmote)
=====

Minimal template engine with default escaping.

Description
-----------

HMote is a fork of [Mote][mote] that uses [Hache][hache]
to auto-escape HTML special characters.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "hmote"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install hmote
```

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

```
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

By default, hmote escapes HTML special characters to prevent [XSS][xss]
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

Contributing
------------

Fork the project with:

```
$ git clone git@github.com:frodsan/hmote.git
```

To install dependencies, use:

```
$ bundle install
```

To run the test suite, do:

```
$ rake test
```

For bug reports and pull requests use [GitHub][issues].

License
-------

HMote is released under the [MIT License][mit].

[mit]: http://www.opensource.org/licenses/MIT
[mote]: https://github.com/soveran/mote
[hache]: https://github.com/frodsan/hache
[issues]: https://github.com/frodsan/hmote/issues
[xss]: http://en.wikipedia.org/wiki/Cross-Site_Scripting
