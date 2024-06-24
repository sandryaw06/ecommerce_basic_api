class V1::ContactsController < ApplicationController

  before_action :find_contact, only: [:show, :create, :update]
  after_action :return_ok, only: [:create, :update]

  def index
    @contacts = Contact.all
    render json: @contacts, status: 200
  end


  def show   
    render json: @contact, status: 200
  end

  def create
    @contact = Contact.new(contact_parametes)
    @contact.save()    
    render json: @contact, status: 200
  end
  
  def update
    @contact.update(contact_parametes)
    render json: @contact, status: 200
  end

  def search
    
    #### first version
    # @contact = Contact.where(["first_name = :value or last_name = :value or email = :value", { value: value }])
    
    ### case-insensitive match
    # @contact = Contact.where(" first_name LIKE :value or last_name LIKE :value or email LIKE :value", { value: "%#{params[:value].downcase}%" })

    if to_boolean(params[:case_sensitive]) 
      @contacts = Contact.where("first_name GLOB :value or last_name GLOB :value or email GLOB :value", { value: "*#{params[:value]}*" })
    else
      @contacts = Contact.where("UPPER(first_name) GLOB :value or UPPER(last_name) GLOB :value or UPPER(email) GLOB :value", { value: "*#{params[:value].upcase}*" })
    end

    render json: @contacts
    
    
  end

  private
  def contact_parametes
    params.require(:contact).permit(:first_name, :last_name, :email)
  end

  def return_ok
    head :ok
  end

  def find_contact
    @contact = Contact.where(id: params[:id]).first
  end

  def to_boolean(attr)
    ActiveRecord::Type::Boolean.new.cast(attr)
  end
  

end
