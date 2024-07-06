class ProductValidator < ActiveModel::Validator

  #mandatory method, with parameter = product = record
  #all conditions are here
  #you can create other methods and referenced here in validate always to use

  def validate(record)

    self.validate_stock(record)
    
  end

  def validate_stock(record)
    if record.stock < 0 
      record.errors.add(:stock, "the stock can not be 0 or negative")
    end
  end

end