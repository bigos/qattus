require 'rails_helper'

RSpec.describe "texts/edit", type: :view do
  let(:text) {
    Text.create!(
      title: "MyString",
      link: "MyString",
      body: "MyText"
    )
  }

  before(:each) do
    assign(:text, text)
  end

  it "renders the edit text form" do
    render

    assert_select "form[action=?][method=?]", text_path(text), "post" do

      assert_select "input[name=?]", "text[title]"

      assert_select "input[name=?]", "text[link]"

      assert_select "textarea[name=?]", "text[body]"
    end
  end
end
