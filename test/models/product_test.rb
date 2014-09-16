require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  #Test 1
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end
  #Test 2
  test "product price must be positive" do
    product = Product.new(title: "My book title", description: "book desc", image_url: "abc.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end
  #Test 3
  def new_product(image_url)
    Product.new(title: "My book title", description: "book desc", image_url: image_url, price: 1)
  end
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.c/x/y/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should be invalid"
    end
  end
  #Test 4
  #fixtures :products
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title, description: "yyy", price: 1, image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
  #modified Test 4, using standard error codes
  test "product is not valid without a unique title - i18n" do
    product = Product.new(title: products(:ruby).title, description: "yyy", price: 1, image_url: "fred.gif")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
  #Test 5 - length on title as suggested at end of chapter
  test "product title must be at least 5 characters" do
    product = Product.new(title: "yup", description: "yyy", price: 1, image_url: "fred.jpg")
    assert product.invalid?
    assert_equal ["is too short (minimum is 5 characters)"], product.errors[:title]
  end
end
