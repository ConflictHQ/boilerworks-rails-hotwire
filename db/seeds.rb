puts "Seeding permissions..."

permission_data = [
  { name: "View Products",    slug: "product.view" },
  { name: "Add Products",     slug: "product.add" },
  { name: "Change Products",  slug: "product.change" },
  { name: "Delete Products",  slug: "product.delete" },
  { name: "View Categories",  slug: "category.view" },
  { name: "Add Categories",   slug: "category.add" },
  { name: "Change Categories", slug: "category.change" },
  { name: "Delete Categories", slug: "category.delete" }
]

permissions = permission_data.map do |attrs|
  Permission.find_or_create_by!(slug: attrs[:slug]) do |p|
    p.name = attrs[:name]
  end
end

puts "  Created #{permissions.size} permissions"

puts "Seeding groups..."

admin_group = Group.find_or_create_by!(name: "Admin")
admin_group.permissions = Permission.all

editor_group = Group.find_or_create_by!(name: "Editor")
editor_group.permissions = Permission.where(slug: %w[product.view category.view])

puts "  Created Admin group (#{admin_group.permissions.count} permissions)"
puts "  Created Editor group (#{editor_group.permissions.count} permissions)"

puts "Seeding admin user..."

admin = User.find_or_initialize_by(email_address: "admin@boilerworks.dev")
admin.assign_attributes(
  password: "password",
  password_confirmation: "password",
  first_name: "Admin",
  last_name: "User"
)
admin.save!
admin.groups = [admin_group] unless admin.groups.include?(admin_group)

puts "  Created admin@boilerworks.dev (password: password)"

puts "Seeding categories..."

categories = {}
[
  { name: "Electronics", slug: "electronics", description: "Electronic devices and accessories" },
  { name: "Clothing", slug: "clothing", description: "Apparel and fashion items" },
  { name: "Home & Garden", slug: "home-garden", description: "Home improvement and garden supplies" }
].each do |attrs|
  cat = Category.find_or_create_by!(slug: attrs[:slug]) do |c|
    c.name = attrs[:name]
    c.description = attrs[:description]
  end
  categories[attrs[:slug]] = cat
end

puts "  Created #{categories.size} categories"

puts "Seeding products..."

products = [
  { name: "Wireless Headphones", slug: "wireless-headphones", description: "Bluetooth noise-cancelling headphones", price: 79.99, category: categories["electronics"] },
  { name: "USB-C Hub", slug: "usb-c-hub", description: "7-in-1 USB-C docking station", price: 49.99, category: categories["electronics"] },
  { name: "Mechanical Keyboard", slug: "mechanical-keyboard", description: "Cherry MX Brown switches, RGB backlit", price: 129.99, category: categories["electronics"] },
  { name: "Denim Jacket", slug: "denim-jacket", description: "Classic fit stonewash denim jacket", price: 89.99, category: categories["clothing"] },
  { name: "Running Shoes", slug: "running-shoes", description: "Lightweight breathable running shoes", price: 119.99, category: categories["clothing"] },
  { name: "Garden Tool Set", slug: "garden-tool-set", description: "5-piece stainless steel garden tool kit", price: 34.99, category: categories["home-garden"] }
]

products.each do |attrs|
  category = attrs.delete(:category)
  Product.find_or_create_by!(slug: attrs[:slug]) do |p|
    p.assign_attributes(attrs)
    p.category = category
  end
end

puts "  Created #{products.size} products"
puts "Seeding complete!"
