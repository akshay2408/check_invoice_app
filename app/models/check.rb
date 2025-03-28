class Check < ApplicationRecord
  belongs_to :company
  has_many :check_invoices
  has_many :invoices, through: :check_invoices
  has_one_attached :image
  attr_accessor :image_data
  validates :number, presence: true, uniqueness: true

  before_save :attach_image

  private

  def attach_image
    byebug
    return unless image_data.include?(',')

    decoded_image = Base64.decode64(image_data.split(',')[1])
    io = StringIO.new(decoded_image)
    image.attach(io: io, filename: "company_logo.jpg", content_type: "image/jpeg")
  end
end

