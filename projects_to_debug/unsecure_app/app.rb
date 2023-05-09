require "sinatra/base"
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    return erb(:index)
  end

  post "/hello" do
    @name = params[:name]

    if @name.include?("<script>")
      status 400
      return erb(:hello)
    end

    return erb(:hello)
  end
end
