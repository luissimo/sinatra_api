require 'rubygems'
require 'active_record'
require 'sinatra'
require 'yaml'

# setting up the environment
env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1 ] if env_index
env = env_arg || ENV["SINATRA_ENV"] || "development"
if env == "test"
	puts "starting in test mode"
	User.destroy_all
	User.create(name: 'paul', 
				email: 'paul@pauldix.net',
				bio: 'rubyist')
end
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
	user = User.create(JSON.parse(request.body.read))
	if user.valid?
		user.to_json
	else
		error 400, user.errors.to_json
	end
	rescue => e
	error 400, e.message.to_json 
end

put 'api/v1/users/:name' do
	user = User.find_by_name(params[:name])
	if user
		begin
			if user.update_attributes(JSON.parse(request.body.read))
				user.to_json
			else
				error 400, user.errors.to_json
			end
		rescue => e
			error 400, e.message.to_json
		end
	else
		error 400, {error: 'user not found'}.to_json
	end
end


delete 'api/v1/users/:name' do 
	user = User.find_by_name(params[:name])
	if user 
		user.destroy
		user.to_json
	else
		error 404, {error: "User not found"}.to_json
	end
end

post '/api/v1/users/:name/sessions' do 
	begin
		attributes = JSON.parse(request.body.read)
		user = User.find_by_name_and_password(
			params[:name], attributes["password"])
		if user
			user.to_json
		else
			error 400, {error: 'invalid login credentials'}.to_json
		end
	rescue => e
		error 404, e.message.to_json
	end
end




