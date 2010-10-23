require 'rubygems'
require "bundler/setup"

require 'sinatra/base'
require 'sinatra/content_for'

class Site < Sinatra::Base
  
  enable  :static
  set     :root, File.dirname(__FILE__)
  set     :public, Proc.new { File.join(root, "public") }
  
  helpers Sinatra::ContentFor
  
  helpers do
    def title(t = nil)
      @title = t if t
      @title
    end
  end
  
  get '/?' do
    title 'Index'
    erb :index
  end
  
  get '/:example_name' do |example_name|
    title example_name
    erb example_name.to_sym
  end
end