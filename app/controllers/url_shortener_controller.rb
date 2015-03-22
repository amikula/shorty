class UrlShortenerController < ApplicationController
  def create
    @url = Url.where(url: params[:url]).first

    unless @url
      @url = Url.create(url: params[:url])

      if @url.errors.present?
        render(text: "{\"error\":\"#{@url.errors.full_messages.join('; ')}\"}", status: 400)
        return
      end
    end
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
