require 'rubygems'
require "bundler/setup"

require 'sinatra/base'
require 'sinatra/content_for'
require 'config'

class Site < Sinatra::Base
  
  enable  :static, :sessions
  set     :root, File.dirname(__FILE__)
  set     :public, Proc.new { File.join(root, "public") }
  
  helpers Sinatra::ContentFor
  
  helpers do
    def title(t = nil)
      @title = t if t
      @title
    end
  end
  
  before do
    session[:user_id] ||= Time.now.to_i
  end
  
  get '/?' do
    title 'Index'
    erb :index
  end
  
  get '/:channel_name/:example_name' do |channel_name, example_name|
    @channel_name = channel_name
    title example_name
    erb example_name.to_sym
  end
end