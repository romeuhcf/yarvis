require 'rails_helper'

RSpec.describe "BuildJobs", type: :request do
  describe "GET /build_jobs" do
    it "works! (now write some real specs)" do
      get build_jobs_path
      expect(response).to have_http_status(200)
    end
  end
end
