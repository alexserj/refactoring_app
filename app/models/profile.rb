# app/models/profile.rb

class Profile < ActiveRecord::Base

  # ...

  has_many :permissions
  has_many :users, through: :permissions
  has_many :media_items,   as: :attachable,    dependent: :destroy

  has_one :address, as: :addressable, conditions: { used_for: 'homebase' }

  accepts_nested_attributes_for :address

  # ...

  delegate  :blocked, to: :main_user

  # ...

  def artist?
    self.is_a?(Artist)
  end

  def promoter?
    self.is_a?(Promoter)
  end

  def main_user
    self.users.where(permissions: {role: 'admin'}).order('id ASC').first
  end
  alias_method :authorized_user, :main_user

  # ...

end
