require_relative "init"

desc "Open console w/ Pry"
task :console do
  Pry.start Pry.toplevel_binding
end

namespace :debug do
  desc "Entry data at interval"
  task :entry do
    require "securerandom"
    loop {
      sh "curl -w '\n' -X POST -d 'iid=#{SecureRandom.hex[0..9]}' localhost:9292/api/v1/statuses"
      sleep 15
    }
  end
end

