#database creation
task :db_create do
	require "./lib/marketing.rb"
	db = Marketing::SqliteConnector.new
	db.create_db
end

#database seeding
task :db_seed do
	require "./lib/marketing.rb"
	marketing = Marketing.new
	params = Hash.new
	10.times do
		#very simple seeding, better to do it from separate file
		params[:email] = (0...8).map{(65+rand(26)).chr}.join
		params[:mobile] = (0..14).map{(65+rand(26)).chr}.join
		params[:company_name] = (0...20).map{(65+rand(26)).chr}.join
		params[:first_name] = (0...20).map{(65+rand(26)).chr}.join
		params[:last_name] = (0...20).map{(65+rand(26)).chr}.join
		params[:permission_type] = "one-time"
		params[:channel] = "sms"
		marketing.new_optin(params.to_json)
	end
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
