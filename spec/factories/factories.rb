FactoryBot.define do
  factory :user do
    # sequence(:email) {|n| "test -#{n.to_s.rjust(3,"0")}@sample.com"}
    email { 'user@example.com' }
    password {"123456"}
  end
end
