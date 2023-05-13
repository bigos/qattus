require 'rails_helper'

RSpec.describe "texts/new", type: :view do
  before(:each) do
    assign(:text, Text.new(
      title: "MyString",
      link: "MyString",
      body: "MyText"
    ))
  end

  it "renders new text form" do
    render

    assert_select "form[action=?][method=?]", texts_path, "post" do

      assert_select "input[name=?]", "text[title]"

      assert_select "input[name=?]", "text[link]"

      assert_select "textarea[name=?]", "text[body]"
    end
  end
end
