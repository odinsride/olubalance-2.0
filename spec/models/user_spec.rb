# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end
  
  describe "user sign up" do
    let!(:user) { FactoryBot.create(:user, confirmed_at: :null) }
    
    it "should send the user a confirmation email on signup" do
      expect(Devise.mailer.deliveries.count).to eq 1
    end

    it "should send the user a confirmation email when email changes" do
      user.update(email: "new-email@gmail.com")
      expect(Devise.mailer.deliveries.count).to eq 2
    end
  end
  
  describe 'validations' do
    let!(:user) { FactoryBot.create(:user) }

    it "requires an email address" do
      user.email = nil
      expect(user).to be_invalid
    end

    it "requires email address to be unique" do 
      user2 = FactoryBot.build(:user, email: user.email)
      expect(user2).to be_invalid
    end

    it "requires email address to be in a valid email format" do
      user.email = "asdf.com123"
      expect(user).to be_invalid
    end

    it "requires a first name" do
      user.first_name = nil
      expect(user).to be_invalid
    end

    it "requires a last name" do
      user.last_name = nil
      expect(user).to be_invalid
    end

    it "requires a time zone" do
      user.timezone = nil
      expect(user).to be_invalid
    end

    it "requires a password" do
      user.password = nil
      expect(user).to be_invalid
    end

    it "requires the password to be a minimum length" do
      user.password = "a"
      expect(user).to be_invalid
    end
  end
end
