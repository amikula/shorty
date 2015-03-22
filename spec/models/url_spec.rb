require 'rails_helper'

RSpec.describe Url, :type => :model do
  %w{http https}.each do |prefix|
    it "creates a 7-character alphanumeric slug automatically if one is not assigned upon create for #{prefix} urls" do
      url = Url.create(url: "#{prefix}://www.example.com/path")
      expect(url.slug).to_not be(nil)
      expect(url.slug.length).to eq(7)
      expect(url.slug).to match(/^[A-Za-z0-9]{7}$/)
    end
  end

  it 'rejects urls that do not start with http:// or https://' do
    expect {
      Url.create!(url: "www.example.com")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'generates the external URL which will be redirected' do
    url = create(:url)

    expect(url.external_url).to eq("http://example.com/#{url.slug}")
  end
end
