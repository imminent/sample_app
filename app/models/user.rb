# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password

	validates :name, presence: true,
					 length: { maximum: 50 }
	VALID_EMAIL_REGEX = 
		/\A((\w|\d|[!#\$%&'*+\-\/=?^`{}|~]|\."(\w|\d|[!#\$%&'*+\-\/=?^`{}|~]|[(),:;<>@\\\[]|\]|\\\( |"|\\\))*"\.|\.)+(?<!\.)|"(\w|\d|[!#\$%&'*+\-\/=?^`{}|~]|[(),:;<>@\\\[]|\]|\\\( |"|\\\))*\")@[a-z0-9\-]{1,63}(?<!-)(\.[a-z0-9\-]{1,63}(?<!-))*\z/i 
	validates :email, presence: true,
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true
end
