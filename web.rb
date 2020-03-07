require "sinatra/base"
if Me.development?
  require "sinatra/reloader"
end

class FrightBoard::Web < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    erb :index
  end

  get "/:board_id" do
    raise Sinatra::NotFound if Board.where(board_id: params[:board_id]).empty?
    @board_id = params[:board_id]
    scheme = request.secure? ? 'https' : 'http'
    @api_endpoint_path = "/api/v1/#{@board_id}"
    @api_endpoint_uri = "#{scheme}://#{request.env['HTTP_HOST']}#{@api_endpoint_path}"
    erb :board
  end
end
