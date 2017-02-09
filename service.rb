require 'rubygems'
require 'active_record'
require 'sinatra'
require 'yaml'


# setting up the environment
env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1 ] if env_index
env = env_arg || ENV["SINATRA_ENV"] || "development"
databases = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(databases[env])


# HTTP Entry Points 
# get a user by name
get '/api/v1/users/:name' do 
	user = User.find_by_name(params[:name])
	if user
		user.to_json
	else
		error 404, {:error => "User not found"}.to_json
	end
end

post '/api/v1/users' do 
	
	end

