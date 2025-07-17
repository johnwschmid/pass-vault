class UserPassword < ApplicationRecord
  belongs_to :user
  belongs_to :password

  ROLES = %w|viewer editor owner|

  validates :role, inclusion: { in: ROLES }
  validates :user_id, presence: true

  attribute :role, default: 'viewer'

  def editor?
    role.in? ['editor', 'owner']
  end
  def owner?
    role == 'owner'
  end
end
