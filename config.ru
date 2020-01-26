require File.join(File.dirname(__FILE__), "init")
require File.join(File.dirname(__FILE__), "applib")
run Rack::Cascade.new [FrightBoard::Web, FrightBoard::API]
