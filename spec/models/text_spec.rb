# == Schema Information
#
# Table name: texts
#
#  id         :integer          not null, primary key
#  title      :string
#  link       :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Text, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
