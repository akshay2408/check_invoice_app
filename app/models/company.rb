class Company < ApplicationRecord
  has_many :invoices
  has_many :checks
  validates :name, presence: true
end
