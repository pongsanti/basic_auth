class User < ActiveRecord::Base
	attr_accessor :password
	
	before_save :encrypt_password

	validates :email, presence: true
	validates :email, uniqueness: true

	validates :password, presence: true, confirmation: true
	validates :password_confirmation, presence: true
	
	def encrypt_password
	  if password.present?
	  	self.password_salt = BCrypt::Engine.generate_salt
	  	self.password_hash = BCrypt::Engine.hash_secret(password, 
	  		password_salt)
	  end
	end

	class << self
		def authenticate(email ,password)
			user = find_by_email(email)
			if user && user.password_hash ==
					BCrypt::Engine.hash_secret(password, user.password_salt)
				user
			else
				nil
			end
		end
	end
end
