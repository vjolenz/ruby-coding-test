class User < ApplicationRecord
  # Track every email change
  audited only: :email, on: [:create, :update]

  enum status: [:non_customer, :customer, :admin]

  validates :email, uniqueness: true, presence: true
  validates_presence_of :first_name, :last_name
  validate :email_should_be_well_formatted

  before_save -> { self.status = :non_customer }, if: -> { status.nil? }

  before_destroy :admin_cannot_be_destroyed

  def email=(val)
    super(val.to_s.strip.downcase)
  end

  private

  def email_should_be_well_formatted
    unless email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      errors[:email] << "#{email} is not a valid email address!"
    end
  end

  def admin_cannot_be_destroyed
    if admin?
      errors.add(:base, 'Admins can not be destroyed!')
      throw(:abort)
    end
  end
end
