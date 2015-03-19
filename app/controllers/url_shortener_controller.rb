class UrlShortenerController < ApplicationController
  def create
    # Create a new Url if it's not already in the database
    @url = Url.where(url: params[:url]).first || Url.create!(url: params[:url])
  end

  def show
    @url = Url.where(slug: params[:id]).first

    respond_to do |format|
      format.json do
        unless @url
          render text: '{"error":"Slug not found"}', status: 404
        end
      end

      format.html do
        if @url
          redirect_to @url.url
        else
          raise ActionController::RoutingError.new('Not Found')
        end
      end
    end
  end
end
