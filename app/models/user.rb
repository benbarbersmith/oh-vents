# == Schema Information
#
# Table name: users
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  screen_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class User < ActiveRecord::Base
  has_many :authorizations
  has_many :events

  def self.create_from_hash!(hash)
    create(:name => hash['info']['name'], :screen_name => hash['info']['nickname'])
  end
end
