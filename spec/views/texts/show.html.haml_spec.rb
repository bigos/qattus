require 'rails_helper'

RSpec.describe "texts/show", type: :view do
  before(:each) do
    assign(:text, Text.create!(
      title: "Title",
      link: "Link",
      body: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Link/)
    expect(rendered).to match(/MyText/)
  end
end
