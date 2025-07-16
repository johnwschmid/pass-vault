class UserPassword < ApplicationRecord
  belongs_to :user
  belongs_to :password

  ROLES = %w|viewer editor owner|

  validates :role, inclusion: { in: ROLES }
  validates :user_id, presence: true

  attribute :role, default: 'viewer'
end
