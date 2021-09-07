# frozen_string_literal: true

# An account which will store many transactions and belongs to one user
class Account < ApplicationRecord
  # associations
  belongs_to :user

  # account types
  enum account_type: {
    checking: 'checking',
    savings: 'savings',
    credit: 'credit',
    cash: 'cash'
  }

  # validations
  validates :name, presence: true,
                   length: { maximum: 50, minimum: 2 },
                   uniqueness: { scope: :user_id }
  validates :starting_balance, presence: true,
                               numericality: true
  validates :last_four, length: { minimum: 4, maximum: 4 },
                        format: { with: /\A\d+\z/, message: 'Numbers only.' },
                        allow_blank: true
  validates :interest_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: proc { |u| u.credit? || u.savings? }
  validates :credit_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: proc { |u| u.credit? }
  validates :account_type, inclusion: {
    in: account_types.keys
  }

  before_create :set_current_balance

  private

  def set_current_balance
    self.current_balance = starting_balance
  end
end
