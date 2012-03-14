class User < ActiveRecord::Base
  has_many :authorizations

  def self.create_from_hash!(hash)
    create(:name => hash['info']['name'], :screen_name => hash['info']['nickname'])
  end
end
