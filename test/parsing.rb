require_relative "helper"

scope("parsing") do
  test "assignment" do
    template = HMote.parse("{{ 1 + 2 }}")

    assert_equal("3", template.call)
  end

  test "control flow" do
    template = (<<-EOT).gsub(/ {4}/, "")
    % if false
      false
    % else
      true
    % end
    EOT

    result = HMote.parse(template).call

    assert_equal("  true\n", result)
  end

  test "parameters" do
    template = (<<-EOT).gsub(/ {4}/, "")
    % params[:n].times do
    *
    % end
    EOT

    example = HMote.parse(template)

    assert_equal("*\n*\n*\n", example[n: 3])
    assert_equal("*\n*\n*\n*\n", example[n: 4])
  end

  test "multiline" do
    example = HMote.parse("The\nMan\nAnd\n{{\"The\"}}\nSea")
    assert_equal("The\nMan\nAnd\nThe\nSea", example[n: 3])
  end

  test "quotes" do
    example = HMote.parse("'foo' 'bar' 'baz'")
    assert_equal("'foo' 'bar' 'baz'", example.call)
  end

  test "context" do
    context = Object.new
    def context.user; "Bruno"; end

    example = HMote.parse("{{ user }}", context)

    assert_equal("Bruno", example.call)
  end

  test "locals" do
    example = HMote.parse("{{ user }}", TOPLEVEL_BINDING, [:user])

    assert_equal("Mayn", example.call(user: "Mayn"))
  end

  test "nil" do
    example = HMote.parse("{{ params[:user] }}", TOPLEVEL_BINDING)

    assert_equal("", example.call(user: nil))
  end

  test "multi-line XML-style directives" do
    template = (<<-EOT).gsub(/^    /, "")
    <?
       res = ""
       [1, 2, 3].each_with_index do |item, idx|
         res << "%d. %d\n" % [idx + 1, item * item]
       end
    ?>
    {{ res }}
    EOT

    example = HMote.parse(template)

    assert_equal("\n1. 1\n2. 4\n3. 9\n\n", example.call)
  end

  test "preserve XML directives" do
    template = (<<-EOT).gsub(/^    /, "")
    <?xml "hello" ?>
    EOT

    example = HMote.parse(template)

    assert_equal("<?xml \"hello\" ?>\n", example.call)
  end

  test "escapes by default" do
    text = %q(<>&"'/)
    template = HMote.parse("{{ params[:text] }}")
    result = template.call(text: text)

    assert_equal("&lt;&gt;&amp;&quot;&#x27;&#x2F;", result)
  end

  test "no escaping please" do
    text = %q(<>&"'/)
    template = HMote.parse("{{! params[:text] }}")
    result = template.call(text: text)

    assert_equal(text, result)
  end
end
