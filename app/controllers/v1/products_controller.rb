class V1::ProductsController < ApplicationController

  include CrudConcern

  before_action :find_product, only: [:update, :destroy]


  def index 

    if params[:search].nil?     
      @products = Product.all
    else
  
      @products = Product.joins(:category).where("categories.name GLOB UPPER(:search) or products.name GLOB UPPER(:search) or description GLOB UPPER(:search)", {search: "*#{params[:search].upcase}*"} )
    end
        
    @products = @products.limit(params[:limit]).offset(params[:offset])

    @products = @products.map{|p| {"id": p.id, "name": p.name, "description": p.description, "category": p.category.name}}
    total = @products.count
    
    render json: {
      products: @products,
      limit: params[:limit],
      offset: params[:offset],
      total: total
    } 
  end


  def create
    @product = Product.create(product_parameters)
    if @product.save
      
      render json: @product
    else
      render json: {errors: @product.errors.full_messages}, status: :unprocessable_entity
    end

  end

  def update
    if @product.update(product_parameters)
      render json: @product
    else
      render json: {errors: true}
    end

  end

  def destroy
    if @product.delete
      render json: {deleted: true}
    else
      render json: {deleted: false, error: true}
    end

  end

  def show
    show_concern({model: "Product", id: params[:id]})
  end
 

  private
  def find_product
    @product = Product.find(params[:id])
  end
  def product_parameters
    params.require(:product).permit(:name, :description, :category_id)
  end
end
 