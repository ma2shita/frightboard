require File.join(File.dirname(__FILE__), "init")
run Rack::Cascade.new [WorkingDashboard::API]
