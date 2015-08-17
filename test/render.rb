require_relative "helper"
require "cuba/test"
require_relative "../lib/hmote/render"

Cuba.plugin(HMote::Render)
Cuba.settings[:hmote][:views] = "./test/views"

Cuba.define do
  def name
    "App"
  end

  on "partial" do
    res.write partial("home")
  end

  on "view" do
    res.write view("home", title: "Hello")
  end

  on "render" do
    render("home", title: "Hola")
  end

  on "context" do
    res.write partial("context")
  end
end

scope do
  test "view renders view with layout" do
    expected = "<title>Hello</title>\n<h1>Home</h1>"

    get "/view"

    assert last_response.body[expected]
  end

  test "partial renders view without layout" do
    get "/partial"

    assert last_response.body["<h1>Home</h1>"]
  end

  test "render renders view with layout" do
    get "/render"

    assert last_response.body["<title>Hola</title>\n<h1>Home</h1>"]
  end

  test "access to application context" do
    get "/context"

    assert last_response.body["App"]
  end
end
