require File.join(File.dirname(__FILE__), "init")

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
      sh "curl -X POST -d 'status=#{st}' localhost:5000/api/v1/statuses?iid=#{iid}"
      puts "" # Line-feed
      sleep (0..3).to_a.sample
    }
  end
end

# http://obfuscurity.com/2011/11/Sequel-Migrations-on-Heroku
namespace :db do
  require "sequel"
  namespace :migrate do
    Sequel.extension :migration

    desc "Perform migration reset (full erase and migration up)"
    task :reset do
      Sequel::Migrator.run(DB, "migrations", :target => 0)
      Sequel::Migrator.run(DB, "migrations")
      puts "<= sq:migrate:reset executed"
    end

    desc "Perform migration up/down to DB_VERSION"
    task :to do
      db_version = ENV['DB_VERSION'].to_i
      raise "No DB_VERSION was provided" if db_version.nil?
      Sequel::Migrator.run(DB, "migrations", :target => db_version)
      puts "<= sq:migrate:to db_version=[#{db_version}] executed"
    end

    desc "Perform migration up to latest migration available"
    task :up do
      Sequel::Migrator.run(DB, "migrations")
      puts "<= sq:migrate:up executed"
    end

    desc "Perform migration down (erase all data)"
    task :down do
      Sequel::Migrator.run(DB, "migrations", :target => 0)
      puts "<= sq:migrate:down executed"
    end
  end
end
