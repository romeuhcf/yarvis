require "rails_helper"

RSpec.describe ChangesetsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/changesets").to route_to("changesets#index")
    end

    it "routes to #new" do
      pending
      expect(:get => "/changesets/new").to route_to("changesets#new")
    end

    it "routes to #show" do
      expect(:get => "/changesets/1").to route_to("changesets#show", :id => "1")
    end

    it "routes to #edit" do
      pending
      expect(:get => "/changesets/1/edit").to route_to("changesets#edit", :id => "1")
    end

    it "routes to #create" do
      pending
      expect(:post => "/changesets").to route_to("changesets#create")
    end

    it "routes to #update" do
      pending
      expect(:put => "/changesets/1").to route_to("changesets#update", :id => "1")
    end

    it "routes to #destroy" do
      pending
      expect(:delete => "/changesets/1").to route_to("changesets#destroy", :id => "1")
    end

  end
end
