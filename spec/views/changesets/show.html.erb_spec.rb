require 'rails_helper'

RSpec.describe "changesets/show", type: :view do
  before(:each) do
    @changeset = assign(:changeset, Changeset.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
