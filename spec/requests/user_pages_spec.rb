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
      before { valid_signup }

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
end