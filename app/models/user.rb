class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tasks
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
end
