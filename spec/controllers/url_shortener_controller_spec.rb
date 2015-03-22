require 'rails_helper'

RSpec.describe UrlShortenerController, :type => :controller do
  context 'POST' do
    render_views

    it 'returns a 200 status' do
      post :create, format: 'json', url: 'http://www.example.com'

      expect(response).to have_http_status(200)
    end

    it 'provides a shortened URL when a long URL is sent' do
      post :create, format: 'json', url: 'http://www.example.com'

      jresponse = JSON.parse(response.body)
      expect(jresponse['shortened_url']).to match(%r{^http://})
    end

    it 'provides a shortened URL whose slug exists in the database and matches the given URL' do
      post :create, format: 'json', url: 'http://www.example.com/test123'

      jresponse = JSON.parse(response.body)
      slug = jresponse['shortened_url'].split('/')[-1]
      expect(Url.where(slug: slug).first.url).to eq('http://www.example.com/test123')
    end

    it 'returns different shortened URLs when different long URLs are sent' do
      post :create, format: 'json', url: 'http://www.example.com/test123'

      jresponse = JSON.parse(response.body)
      shorty1 = jresponse['shortened_url']

      post :create, format: 'json', url: 'http://www.example.com/test456'

      jresponse = JSON.parse(response.body)
      shorty2 = jresponse['shortened_url']

      expect(shorty1).to_not eq(shorty2)
    end

    it 'returns the same shortened URL when the same long URL is sent' do
      post :create, format: 'json', url: 'http://www.example.com/test'

      jresponse = JSON.parse(response.body)
      shorty1 = jresponse['shortened_url']

      post :create, format: 'json', url: 'http://www.example.com/test'

      jresponse = JSON.parse(response.body)
      shorty2 = jresponse['shortened_url']

      expect(shorty1).to eq(shorty2)
    end

    it 'returns a 400 error when an invalid URL is sent' do
      post :create, format: 'json', url: 'www.example.com'

      expect(response).to have_http_status(400)

      expect(JSON.parse(response.body)['error']).to eq("Url is invalid")
    end
  end

  context 'GET' do
    describe 'json format' do
      render_views

      it 'returns the correct long URL when the shortened URL is requested' do
        url = create(:url)

        get :show, format: 'json', id: url.slug

        expect(JSON.parse(response.body)['url']).to eq(url.url)
      end

      it 'returns 404 when the shortened URL is not found' do
        get :show, format: 'json', id: 'NOSUCHSLUG'

        expect(response).to have_http_status(404)
      end

      it 'returns an error message when the shortened URL is not found' do
        get :show, format: 'json', id: 'NOSUCHSLUG'

        expect(JSON.parse(response.body)['error']).to eq('Slug not found')
      end
    end

    describe 'default format' do
      it 'redirects to the correct long url when the shortened URL is requested' do
        url = create(:url)

        get :show, id: url.slug

        expect(response).to redirect_to(url.url)
      end

      it 'Raises a RoutingError to render standard 404 when the shortened URL is not found' do
        expect {
          get :show, id: 'NOSUCHSLUG'
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
