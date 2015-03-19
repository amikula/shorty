class Url < ActiveRecord::Base
  SLUG_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a

  before_save do
    unless self.slug.present?
      self.slug = (1..7).collect{SLUG_CHARS[rand(SLUG_CHARS.length)]}.join("")
    end
  end
end
