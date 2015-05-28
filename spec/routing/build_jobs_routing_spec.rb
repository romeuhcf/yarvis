require "rails_helper"

RSpec.describe BuildJobsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/build_jobs").to route_to("build_jobs#index")
    end

    it "routes to #show" do
      expect(:get => "/build_jobs/1").to route_to("build_jobs#show", :id => "1")
    end

    it "routes to #create" do
      pending
      expect(:post => "/build_jobs").to
    end
  end
end
