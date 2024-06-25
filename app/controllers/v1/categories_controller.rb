class V1::CategoriesController < ApplicationController

  before_action :get_category, only: [:show, :destroy, :update]
  
  def index
    @categories = Category.all
    #@categories = Product.joins(:category)#.where(name: "A")
   # @categories = Category.joins(:products).distinct
   respond_to do |format|
    format.json { render json: @categories, include: {
      products: { only: [:id, :name] },
      user: { only: [:id, :username] }
    }}
    format.xml { render xml: @categories}
   end
    # render json: @categories, include: :products

  end

  def show
    render json: @category
  end

  def create 
    @category = Category.create(category_parameters)
    if @category.save
      render json: @category
    else
      render json: {errors: @category.errors.full_messages}, status: :unprocessable_entity
    end
    
  end

  def update
    if @category.update(category_parameters)
      render json: @category
    end
  end

  def destroy     
    if @category.destroy
      render json: {messsage: "ok"}
    end
  end

  def product_search
    @products = Product.where(category_id: params[:id]).limit(params[:limit]).offset(params[:offset])
    render json: {
      "products": @products.map{|p| {"id" => p.id, "name" => p.name, "price" => p.price}}.sort_by { |hash| hash["name"] }
    }
  end

  private 

  def get_category
    @category = Category.find(params[:id])
  end

  def category_parameters
    params.require(:category).permit(:name)
  end
end
