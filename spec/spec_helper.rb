require "rspec"
require "pry"
require "pry-byebug"

Dir[File.expand_path(File.join(__FILE__, "../../app/**/*.rb"))].each { |f| require f }
