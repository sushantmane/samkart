class Product < ActiveRecord::Base
  validates :title, presence: true,
                    uniqueness: true
  validates :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :image_url, allow_blank: true, format: {
                      with: %r{\.(gif|jpg|png)\Z}i,
                      meassage: 'must be URL for GIF, JPG or PNG image.'
                      }
end
