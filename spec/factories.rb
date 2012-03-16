FactoryGirl.define do
	factory :user do
		name     "Michael Hartl"
		email    "michael@example.com"
		password "password"
		password_confirmation "password"
	end
end