require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_selector 'h1',    text: 'Sign in' }
		it { should have_selector 'title', text: 'Sign in' }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_selector 'title', text: 'Sign in' }
			it { should have_error_message 'Invalid' }
			
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_error_message }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create :user }
			before { valid_signin user }

			it { should have_selector 'title', text: user.name }

			it { should have_user_specific_links }
			it { should have_link 'Sign out', href: signout_path }
			
			it { should_not have_link 'Sign in', href: signin_path }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link 'Sign in' }
				it { should_not have_user_specific_links }
			end
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create :user }

			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path user }
					it { should have_selector 'title', text: 'Sign in' }
				end

				describe "submitting to the update action" do
					before { put user_path user }
					specify { response.should redirect_to signin_path }
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_selector 'title', text: 'Sign in' }
				end
			end

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path user
					valid_signin user
				end

				describe "after signing in" do

					it "should render the desired protected page" do
						page.should have_selector 'title', text: 'Edit user'
					end

					describe "when signing in again" do
						before { sign_in user }
						it "should render the default (profile) page" do
							page.should have_selector 'title', text: user.name
						end
					end
				end
			end

			describe "in the Microposts controller" do

				describe "submitting to the create action" do
					before { post microposts_path }
					specify { response.should redirect_to signin_path }
				end

				describe "submitting to the destroy action" do
					let(:micropost) { FactoryGirl.create :micropost }
					before { delete micropost_path micropost}
					specify { response.should redirect_to signin_path }
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create :user }
			let(:wrong_user) { FactoryGirl.create :user, email: "wrong@example.com" }
			before { sign_in user }

			describe "visiting Users#edit page" do
				before { visit edit_user_path wrong_user }
				it { should have_selector 'title', text: full_title('') }
			end

			describe "submitting a PUT request to the Users#update action" do
				before { put user_path wrong_user }
				specify { response.should redirect_to root_path }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create :user }
			let(:non_admin) { FactoryGirl.create :user }
			before { sign_in non_admin }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path user }
				specify { response.should redirect_to root_path }
			end
		end

		describe "as an admin" do
			let(:admin) { FactoryGirl.create :admin }
			before { sign_in admin }

			describe "submitting a DELETE request to the Users#destroy action on self" do
				it "should not change the number of users" do
					expect { delete user_path admin }.not_to change(User, :count)
				end
			end
		end

		describe "for signed in user" do
			let(:user) { FactoryGirl.create :user }
			before { sign_in user }

			describe "accessing the new action" do
				before { get new_user_path }
				specify { response.should redirect_to root_path }
			end

			describe "accessing the create action" do
				before { post users_path }
				specify { response.should redirect_to root_path }
			end
		end
	end
end
