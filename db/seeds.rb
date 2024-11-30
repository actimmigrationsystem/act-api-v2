# db/seeds.rb
superadmin_email = ENV["SUPERADMIN_EMAIL"] || "superadmin@example.com"
superadmin_password = ENV["SUPERADMIN_PASSWORD"]

if superadmin_password.nil?
  puts "Error: SUPERADMIN_PASSWORD environment variable is not set!"
  exit
end

User.find_or_create_by(email: superadmin_email) do |user|
  user.password = superadmin_password
  user.role = "superadmin"
end

puts "Superadmin created: #{superadmin_email}"


# Admin credentials
admin_email = ENV["ADMIN_EMAIL"] || "admin@example.com"
admin_password = ENV["ADMIN_PASSWORD"]

if admin_password.nil?
  puts "Error: ADMIN_PASSWORD environment variable is not set!"
  exit
end

User.find_or_create_by(email: admin_email) do |user|
  user.password = admin_password
  user.role = "admin"
end

puts "Admin created: #{admin_email}"

# Client credentials (no environment variables required for test user)
client_email = "client@email.com"
client_password = "Client12456"

User.find_or_create_by(email: client_email) do |user|
  user.password = client_password
  user.role = "client"
end

puts "Client created: #{client_email}"