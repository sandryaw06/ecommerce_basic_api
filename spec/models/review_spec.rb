# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  starts      :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Review, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
