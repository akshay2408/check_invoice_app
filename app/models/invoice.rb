class Invoice < ApplicationRecord
  belongs_to :company
  has_many :check_invoices
  has_many :checks, through: :check_invoices
  validates :number, presence: true, uniqueness: true
end
