class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy
  has_many :categories, dependent: :destroy


  validates :email, 
    presence: true, 
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, on: :create,presence: true, if: :password_required?

 private

  def password_required?
    new_record? || !password.nil?
  end
  
end
