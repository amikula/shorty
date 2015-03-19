require 'rails_helper'

RSpec.describe Url, :type => :model do
  it 'creates a 7-character alphanumeric slug automatically if one is not assigned upon create' do
    url = Url.create(url: "http://www.example.com/path")
    expect(url.slug).to_not be(nil)
    expect(url.slug.length).to eq(7)
    expect(url.slug).to match(/^[A-Za-z0-9]{7}$/)
  end
end
