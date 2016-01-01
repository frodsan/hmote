require_relative "helper"

class HelpersTest < Minitest::Test
  include HMote::Helpers

  setup do
    hmote_cache.clear
  end

  def foo
    "foo"
  end

  test "using functions in the context" do
    assert_equal("foo\n", hmote("test/foo.mote"))
  end

  test "passing in a context" do
    assert_raises(NameError) do
      hmote("test/foo.mote", {}, TOPLEVEL_BINDING)
    end
  end
end
