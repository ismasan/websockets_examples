# Websocket examples for Rubyconf Uruguay 2010

## Usage

Socket servers are in sockets/. There's a Sinatra site with pages that listen to different socket servers.

Start one or more socket server examples.

    ruby sockets/basic_chat.rb
    

Start the site:

    rackup -p 3000
    
Navigate to localhost:3000. You should see an index of available examples.

## Installation

You'll need the Bundler gem installed to manage dependencies.

    gem install bundler
    
Now you can clone and install dependencies

    git clone http://github.com/ismasan/websockets_examples.git
    cd websockets_examples
    bundle install