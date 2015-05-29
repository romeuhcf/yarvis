require 'rails_helper'

RSpec.describe "Changesets", type: :request do
  describe "GET /changesets" do
    it "works! (now write some real specs)" do
      get changesets_path
      expect(response).to have_http_status(200)
    end
  end
end
