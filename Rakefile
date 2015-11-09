require_relative "init"

desc "Open console w/ Pry"
task :console do
  Pry.start Pry.toplevel_binding
end

namespace :demo do
  desc "Entry demo data at interval"
  task :data do
    loop {
      iid = "pc-#{(0..9).to_a.sample}"
      st = %w(created waiting running blocked terminated).sample
      sh "curl -X POST -d 'status=#{st}' localhost:9292/api/v1/statuses?iid=#{iid}"
      puts "" # Line-feed
      sleep (0..3).to_a.sample
    }
  end
end

