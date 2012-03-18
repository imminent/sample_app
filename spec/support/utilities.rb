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
    fill_in "Confirm Password", with: "password"
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

def write_a_micropost
	fill_in 'micropost_content', with: "Lorem ipsum"
end

def create_a_couple_microposts_for user
	FactoryGirl.create :micropost, user: user, content: "Lorem ipsum"
	FactoryGirl.create :micropost, user: user, content: "Dolor sit amet"
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

RSpec::Matchers.define :have_notice do |message|
	match do |page|
		page.should have_selector 'div.alert.alert-notice', text: message
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

RSpec::Matchers.define :have_user_specific_links do
	match do |page|
		page.should have_link 'Users',    href: users_path
		page.should have_link 'Profile',  href: user_path(user)
		page.should have_link 'Settings', href: edit_user_path(user)
	end
end

RSpec::Matchers.define :list_the_first_page_of_users do
	match do |page|
		first_page.each do |user|
          page.should have_selector 'li', text: user.name
        end
    end
end

RSpec::Matchers.define :list_the_second_page_of_users do
	match do |page|
		second_page.each do |user|
          page.should have_selector 'li', text: user.name
        end
    end
end

RSpec::Matchers.define :have_microposts_in_the_right_order do
	match do |user|
		user.microposts.should == [newer_micropost, older_micropost]
	end
end

RSpec::Matchers.define :destroy_microposts_associated_with_destroyed_user do
	match do |user|
		microposts = user.microposts
		user.destroy
		microposts.each do |micropost|
			Micropost.find_by_id(micropost.id).should be_nil
		end
	end
end 

RSpec::Matchers.define :render_their_feed do
	match do |page|
		user.feed.each do |item|
			page.should have_selector "li##{item.id}", text: item.content
		end
	end
end