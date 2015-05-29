require 'rails_helper'

RSpec.describe "build_jobs/index", type: :view do
  before(:each) do
    assign(:build_jobs, [
      BuildJob.create!(),
      BuildJob.create!()
    ])
  end

  it "renders a list of build_jobs" do
    render
  end
end
