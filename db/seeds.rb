# require 'securerandom'

# SuperAdmin credentials
superadmin_email = ENV['SUPERADMIN_EMAIL']
superadmin_password = ENV['SUPERADMIN_PASSWORD']

if superadmin_password.nil?
  puts 'Error: SUPERADMIN_PASSWORD environment variable is not set!'
  exit
end

User.find_or_create_by(email: superadmin_email) do |user|
  user.password = superadmin_password
  user.role = 'superadmin'
  user.auth_token ||= SecureRandom.hex(20)
end

puts "Superadmin created: #{superadmin_email}"

# Admin credentials
admin_email = ENV['ADMIN_EMAIL'] ||
              admin_password = ENV['ADMIN_PASSWORD']

if admin_password.nil?
  puts 'Error: ADMIN_PASSWORD environment variable is not set!'
  exit
end

User.find_or_create_by(email: admin_email) do |user|
  user.password = admin_password
  user.role = 'admin'
  user.auth_token ||= SecureRandom.hex(20)
end

puts "Admin created: #{admin_email}"

# Client credentials (no environment variables required for test user)
client_email = 'client@email.com'
client_password = 'Client12456'

User.find_or_create_by(email: client_email) do |user|
  user.password = client_password
  user.role = 'client'
  user.auth_token ||= SecureRandom.hex(20)
end

puts "Client created: #{client_email}"

# Create a profile for each user
User.find_each do |user|
  user.create_profile(
    first_name: 'YourName',
    last_name: 'LastName',
    phone_number: '123-456-7890',
    address: 'Default Address'
  )
end

puts 'Profiles created for all users'
