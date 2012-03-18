def full_title page_title
	base_title = "Ruby on Rails Tutorial Sample App"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

def valid_signin user
	fill_in "Email",    with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
end

def sign_in user
	visit signin_path
	valid_signin user
	# Sign in when not using Capybara as well.
  	cookies[:remember_token] = user.remember_token
end


def fill_signup_form_with_valid_information
    fill_in "Name",         with: "Example User"
    fill_in "Email",        with: "user@example.com"
    fill_in "Password",     with: "password"
    fill_in "Confirmation", with: "password"
end

def valid_update user, update = { }
	fill_in "Name",             with: update[:name] unless update[:name].nil?
	fill_in "Email",            with: update[:email] unless update[:email].nil?
	fill_in "Password",         with: user.password
	fill_in "Confirm Password", with: user.password
	click_button "Save changes"
end 

def setup_test_users
	FactoryGirl.create :user, name: "Bob", email: "bob@example.com"
	FactoryGirl.create :user, name: "Ben", email: "ben@example.com"
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector 'div.alert.alert-error', text: message
	end
end

RSpec::Matchers.define :have_success_message do |message|
	match do |page|
		page.should have_selector 'div.alert.alert-success', text: message
	end
end

RSpec::Matchers.define :list_each_user do
	match do |page|
		User.all[0..2].each do |user|
			page.should have_selector 'li', text: user.name
		end
	end
end

RSpec::Matchers.define :be_able_to_delete_another_user do
	match do |page|
		expect { page.click_link 'delete' }.to change(User, :count).by(-1)
	end
end