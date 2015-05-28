class BuildJobsController < ApplicationController
  before_action :set_build_job, only: [:show, :edit, :update, :destroy]

  # GET /build_jobs
  # GET /build_jobs.json
  def index
    @build_jobs = BuildJob.all
  end

  # GET /build_jobs/1
  # GET /build_jobs/1.json
  def show
  end

  # GET /build_jobs/new
  def new
    @build_job = BuildJob.new
  end

  # GET /build_jobs/1/edit
  def edit
  end

  # POST /build_jobs
  # POST /build_jobs.json
  def create
    @build_job = BuildJob.new(build_job_params)

    respond_to do |format|
      if @build_job.save
        format.html { redirect_to @build_job, notice: 'Build job was successfully created.' }
        format.json { render :show, status: :created, location: @build_job }
      else
        format.html { render :new }
        format.json { render json: @build_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /build_jobs/1
  # PATCH/PUT /build_jobs/1.json
  def update
    respond_to do |format|
      if @build_job.update(build_job_params)
        format.html { redirect_to @build_job, notice: 'Build job was successfully updated.' }
        format.json { render :show, status: :ok, location: @build_job }
      else
        format.html { render :edit }
        format.json { render json: @build_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /build_jobs/1
  # DELETE /build_jobs/1.json
  def destroy
    @build_job.destroy
    respond_to do |format|
      format.html { redirect_to build_jobs_url, notice: 'Build job was successfully destroyed.' }
      format.json { head :no_content }
    end
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
