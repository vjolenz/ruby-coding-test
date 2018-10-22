class User < ApplicationRecord
  validates :email, uniqueness: true

  before_validation do
    self.email = email.downcase!
  end
end
