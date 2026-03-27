FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password" }
    first_name { "Test" }
    last_name { "User" }
    uuid { SecureRandom.uuid }

    trait :admin do
      after(:create) do |user|
        admin_group = Group.find_or_create_by!(name: "admin") do |g|
          Permission.find_each { |p| g.permissions << p unless g.permissions.include?(p) }
        end
        user.groups << admin_group unless user.groups.include?(admin_group)
      end
    end
  end
end
