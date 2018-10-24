FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    status { User.statuses[:non_customer] }
  end

  factory :admin_user, parent: :user do
    status { User.statuses[:admin] }
  end
end