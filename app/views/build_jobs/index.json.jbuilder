json.array!(@build_jobs) do |build_job|
  json.extract! build_job, :id
  json.url build_job_url(build_job, format: :json)
end
