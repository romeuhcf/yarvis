require 'rails_helper'

RSpec.describe "build_jobs/show", type: :view do
  before(:each) do
    @build_job = assign(:build_job, BuildJob.new())
  end

  it "renders attributes in <p>" do
    render
  end
end
