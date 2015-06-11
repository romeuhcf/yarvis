class BuildJobsController < ApplicationController
  before_action :set_build_job, only: [:show, :step_log]

  # GET /build_jobs
  # GET /build_jobs.json
  def index
    @build_jobs = BuildJob.all
  end


  def step_log
    @log_cruncher = BuildLogCruncher.new(@build_job)
    @crunch = @log_cruncher.crunches[params[:crunch]]
    render layout: false
  end

  # GET /build_jobs/1
  # GET /build_jobs/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build_job
      @build_job = BuildJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_job_params
      params[:build_job]
    end
end
