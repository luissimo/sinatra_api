require File.dirname(__FILE__) + '/../service' 
require 'spec'
require 'spec/interop/test'
require 'rack/test'

set :environment, :test 
Test::Unit::TestCase.send :include, Rack::Test::Methods

def app
	Sinatra::Application
end

describe "service" do 
	before(:each) do 
		User.delete_all
	end

	describe "GET on /api/v1/users/:id" do
		before(:each) do 
			User.create(
				:name => "Paul",
				:email => "paul@pauldix.net",
				:password => "strongpass",
				:bio => "Rubyist")
		end

		it 'should return a user by name' do 
			get '/api/v1/users/paul'
			last_response.should be_ok
			attributes = JSON.parse(last_response.body)
			attributes["name"].should == "paul"
		end

		it "should return a user with an email" do 
			get '/api/v1/users/paul'
			last_response.should be_ok
			attributes = JSON.pase(last_response.body)
			attributes["email"].should == "paul@pauldix.net"
		end

		it "should return a user's password" do 
			get '/api/v1/users/paul'
			last_response.should be_ok
			attributes = JSON.parse(last_response.body)
			attributes.should_not have_key("password")
		end

		it 'should return a user with a bio' do
			get '/api/v1/users/paul'
			last_response.should be_ok
			attributes = JSON.parse(last_response.body)
			attributes["bio"].should == "Rubyist"
		end

		it "should return a 404 for a user that doesnt exist" do
			get '/api/v1/users/foo'
			last_response.status.should  == 404
		end
	end

	describe "Post on /api/v1/users" do 
		it "should create a user" do 
			post '/api/v1/users', {
				name: "trotter",
				email: "no spam",
				password: "whatever",
				bio: "southern belle"}.to_json
			last_response.should be_ok
			get 'api/v1/users/trotter'
			attributes = JSON.parse(last_response.body)
			attributes["name"].should == "trotter"
			attributes["email"].should == "no spam"
			attributes["bio"].should == "southern belle"
end

