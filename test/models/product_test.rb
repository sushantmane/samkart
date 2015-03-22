require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(title:        'This is product title',
                          description:  'This is product description',
                          image_url:    'product_image_url.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title:        'This is product title',
                description:  'This is description of product',
                price:        1,
                image_url:    image_url)
  end

  test 'image url' do
    ok = %w{ thumb.gif thumb.jpg thumb.png THUMB.GIF thumb.jpg thumb.PNG
             http://www.samkart.com/product/images/product_tumbnail.gif }

    bad = %w{  thumb.doc thumb.jpg/img thumb.img thumb.png.img }

    ok.each do |name|
      assert new_product(name).valid?, "#{ name } must be valid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{ name } must not be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(title:        products(:saree).title,
                          description: 'product desc',
                          price:        1,
                          image_url:  'stylus-series-black-semi-stitched-gown.jpg')

    assert product.invalid?
    assert_equal ['has already been taken'], product.errors[:title]
  end
end

