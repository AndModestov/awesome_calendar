class User < ApplicationRecord
  has_many :events, dependent: :destroy

  validates :email, presence: true, format: /@/
  validates :name, length: { maximum: 45 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
end
