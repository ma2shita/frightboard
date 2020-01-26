require "sinatra/base"
require "sinatra/reloader"

class FrightBoard::Web < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    erb :index
  end

  get "/:board_id" do
    p params[:board_id]
    raise Sinatra::NotFound if Board.where(board_id: params[:board_id]).empty?
    @board_id = params[:board_id]
    erb :board
  end
end
