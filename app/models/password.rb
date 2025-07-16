class Password < ApplicationRecord
  has_many :user_passwords, dependent: :destroy
  has_many :users, through: :user_passwords

  encrypts :username, deterministic: true
  encrypts :password

  validates :url, presence: true
  validates :username, presence: true
  validates :password, presence: true

  def editable_by? user
    user_passwords.find_by(user: user).role.in? ['editor', 'owner']
  end

  def owned_by? user
    user_passwords.find_by(user: user).role == 'owner'
  end
end
