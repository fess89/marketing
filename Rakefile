#gem installation
task :build do 
	#getting gem info
	gemspec = eval(File.read("marketing.gemspec"))
	system "gem build marketing.gemspec"
	system "gem install marketing-#{gemspec.version.to_s}.gem --no-ri --no-rdoc"
end

#database creation
task :db_create do
	require 'marketing'
	db = Marketing::SqliteConnector.new
	db.create_db
end

#by default, rake runs tests
desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new do |task|
    task.pattern = "spec/*_spec.rb"
    task.rspec_opts = Dir.glob("[0-9][0-9][0-9]_*").collect { |x| "-I#{x}" }.sort
    task.rspec_opts << '--color'
    task.rspec_opts << '-f documentation'
end
