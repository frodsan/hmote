require_relative "helper"

class Cutest::Scope
  include HMote::Helpers

  def foo
    "foo"
  end
end

scope("helpers") do
  prepare do
    hmote_cache.clear
  end

  test "using functions in the context" do
    assert_equal("foo\n", hmote("test/foo.mote"))
  end

  test "passing in a context" do
    assert_raise(NameError) do
      hmote("test/foo.mote", {}, TOPLEVEL_BINDING)
    end
  end
end
