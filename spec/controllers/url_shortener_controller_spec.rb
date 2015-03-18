require 'rails_helper'

RSpec.describe UrlShortenerController, :type => :controller do
  context 'POST' do
    it 'provides a shortened URL when a long URL is sent'
    it 'returns an error when an invalid url is sent'
    it 'returns the same shortened URL when the same long URL is sent'
  end

  context 'GET' do
    it 'redirects to the correct long url when the shortened URL is requested'
    it 'returns 404 when the shortened URL is not found'
  end
end
