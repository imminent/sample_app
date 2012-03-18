require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "signup page" do
		before { visit signup_path }

		it { should have_selector 'h1', text: 'Sign up' }
		it { should have_selector 'title', text: full_title('Sign up') }
  end

  describe "profile page" do
		let(:user) { FactoryGirl.create :user }
		before { visit user_path user }

		it { should have_selector 'h1', text: user.name }
		it { should have_selector 'title', text: user.name }
  end

  describe "signup" do
    before { visit signup_path }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Create my account" }.not_to change(User, :count)
      end


      describe "error messages" do
        before { click_button "Create my account" }

        it { should have_selector 'title', text: 'Sign up' }
        it { should have_content 'error' }
        it { should have_content '6' }
      end
    end

    describe "with valid information" do
      before { fill_signup_form_with_valid_information }

      it "should create a user" do
        expect { click_button "Create my account" }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button "Create my account" }
        let(:user) { User.find_by_email 'user@example.com' }

        it { should have_selector 'title', text: user.name }
        it { should have_success_message 'Welcome' }
        it { should have_link 'Sign out' }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create :user }
    before do
      sign_in user
      visit edit_user_path user
    end

    describe "page" do
      it { should have_selector 'h1',    text: "Update your profile" }
      it { should have_selector 'title', text: "Edit user" }
      it { should have_link 'change', href: 'http://gravatar.com/emails' }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before { valid_update user, name: new_name, email: new_email }

      it { should have_selector 'title', text: new_name }
      it { should have_success_message }
      it { should have_link 'Sign out', href: signout_path }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create :user }
    before do
      setup_test_users
      sign_in user
      visit users_path
    end

    it { should have_selector 'title', text: 'All users' }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create :user } }
      after(:all)  { User.delete_all }

      let(:first_page)  { User.paginate page: 1 }
      let(:second_page) { User.paginate page: 2 }

      it { should have_link 'Next' }
      it { should have_link '2' }

      it { should list_each_user }

      it { should_not have_link 'delete' }

      it { should list_the_first_page_of_users }
      it { should_not list_the_second_page_of_users }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create :admin }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link 'delete', href: user_path(User.first) }
        it { should be_able_to_delete_another_user }
        it { should_not have_link 'delete', href: user_path(admin) }
      end
    end
  end
end