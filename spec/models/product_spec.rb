require 'rails_helper'

# frozen_string_literal: true

RSpec.describe Product, type: :request do

  describe "Product API" do
    it "return all products" do
        
        expect(true).to eq(true)
    end
  end

  it "create product with category" do
    category = Category.create(name: "Electronics")
    product = Product.create(name: "Smartphone", category: category)
   
    expect(category.products).to include(product)
  end
end


RSpec.describe Product, type: :model do
  # it "test a positive number" do
  #   expect(1).to be_positive 
  #   expect(5).to be > 10  
  # end

  describe '#validations' do 

    let(:product) {build(:product)}
   

    
    #  it "Test builder factory" do
      
    #    expect(product).to be_valid  
    #  end

    # it "Test valid title" do
    #   product.title = ''
    #   expect(product.title).not_to be_valid
    #   expect(product.errors[:title]).to include("can't be blank")  
    # end
  end

end
