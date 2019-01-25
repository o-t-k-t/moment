class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable
  # removed :rememberable

  attr_encrypted :api_key, key: if Rails.env.test? || Rails.env.development?
                                  '12345678123456781234567812345678'
                                else
                                  ENV['MOMENT_USER_API_KEY_CRYPTION_KEY']
                                end
  attr_encrypted :secret_key, key: if Rails.env.test? || Rails.env.development?
                                     '12345678123456781234567812345678'
                                   else
                                     ENV['MOMENT_USER_API_KEY_CRYPTION_KEY']
                                   end
  has_many :bots, dependent: :destroy

  validates :api_key, length: { is: 16 }
  validates :secret_key, length: { is: 32 }
end
