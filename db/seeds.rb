# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



companies = [
  { name: "Tech Corp" },
  { name: "Finance Solutions" },
  { name: "Retail Express" },
  { name: "Healthcare Innovations" },
  { name: "Logistics Global" }
]

companies.each do |company|
  Company.find_or_create_by!(company)
end

puts "✅ Created #{Company.count} companies!"

unless User.find_by(email: "admin@example.com",).present?
  User.find_or_create_by(
    email: "admin@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
end
