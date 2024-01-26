FactoryBot.define do
  factory :user do
    # sequence(:email) {|n| "test -#{n.to_s.rjust(3,"0")}@sample.com"}
    email { 'user@example.com' }
    password {"123456"}
  end

  factory :task do
    title {'Test task'}
    description {'This is a proper description'}
  end
end
