hmote
=====

Minimal template engine with default escaping.

Usage
-----

This is a basic example:

```ruby
require "hmote"

template = HMote.parse("your template goes here!")
template.call
# => "your template goes here!"
```

HMote recognizes two tags to evaluate Ruby code: `%` and `{{}}`.
The difference between them is that while the `%` tag only evaluates
the code, the `{{}}` tag also prints the result to the template.

Imagine that your template looks like this:

```ruby
% gems = ["rack", "cuba", "hmote"]

<ul>
% gems.sort.each do |gem|
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

Installation
------------

```
$ gem install hmote
```
