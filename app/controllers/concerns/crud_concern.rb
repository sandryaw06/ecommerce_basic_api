module CrudConcern
  extend ActiveSupport::Concern

  included do
    # before action will be allways oriented to routes. the params will be the routes 
    #before_action(only: [:show]) {get_resource}
  
    # before_filter :except => [:show, :search] do |controller| controller.authorize({"required_user_level" => "administrator"})


    #{module: "Product", id: params[:id]}
    def show_concern(params)
      get_resource(params)
      render plain: @resource.name
    end

    def get_resource(params)

      puts "n/n/ show example  #{params.to_json}n/n/"

      case params[:model]
      when "Product"
        @resource = Product.find(params[:id])
      end

    end

  end

  class_methods do

  end

end