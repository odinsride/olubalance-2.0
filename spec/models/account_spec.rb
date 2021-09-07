# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:account)).to be_valid
  end

  describe 'account creation' do
    let(:account) { FactoryBot.create(:account) }
    
    it 'should set the current balance to the starting balance' do
      expect(account.current_balance).to_not eq nil
      expect(account.current_balance).to eq account.starting_balance
    end
  end

  # describe 'validations' do
  #   it { should validate_presence_of(:name) }
  #   it { should validate_presence_of(:starting_balance) }
  #   it { should allow_value(150.51).for(:starting_balance) }
  #   it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  #   it { should allow_value('My Account').for(:name) }
  #   it { should_not allow_value('A').for(:name) }
  #   it { should_not allow_value('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA').for(:name) }
  #   it { should allow_value('1234').for(:last_four) }
  #   it { should allow_value(nil).for(:last_four) }
  #   it { should_not allow_value('12').for(:last_four) }
  #   it { should_not allow_value('12345').for(:last_four) }
  #   it { should_not allow_value('ASDF').for(:last_four) }
  #   it { should define_enum_for(:account_type).with_values(checking: 'checking', credit: 'credit', cash: 'cash', savings: 'savings').backed_by_column_of_type(:enum) }

  #   context 'credit account' do
  #     before { allow(subject).to receive(:credit?).and_return(true) }
  #     it { should validate_presence_of(:interest_rate) }
  #     it { should allow_value(20.00).for(:interest_rate) }
  #     it { should_not allow_value('ASDF').for(:interest_rate) }
  #     it { should_not allow_value(-10.00).for(:interest_rate) }
  #     it { should validate_presence_of(:credit_limit) }
  #     it { should allow_value(9000.00).for(:credit_limit) }
  #     it { should_not allow_value('ASDF').for(:credit_limit) }
  #     it { should_not allow_value(-5000.00).for(:credit_limit) }
  #   end

  #   context 'savings account' do
  #     before { allow(subject).to receive(:savings?).and_return(true) }
  #     it { should validate_presence_of(:interest_rate) }
  #     it { should allow_value(20.00).for(:interest_rate) }
  #     it { should_not allow_value('ASDF').for(:interest_rate) }
  #     it { should_not allow_value(-10.00).for(:interest_rate) }
  #   end
  # end

  describe "validations" do
    let!(:account) { FactoryBot.create(:account) }

    it "requires an account name" do
      account.name = nil
      expect(account).to be_invalid
    end

    it "has a unique account name within the user's accounts" do
      # User 2 can create an account with the same name
      user2 = FactoryBot.create(:user, email: 'someotheruser@olubalance.com')
      user2_account = FactoryBot.create(:account, name: account.name, user: user2)
      expect(user2_account).to be_valid

      # Original user cannot create an account with the same name
      account2 = FactoryBot.build(:account, name: account.name, user_id: account.user_id)
      expect(account2).to be_invalid
    end

    it "requires account name to have a minimum length" do
      account.name = "a"
      expect(account).to be_invalid
    end

    it "requires account name to have a maximum length" do
      account.name = "a" * 100
      expect(account).to be_invalid
    end

    it "requires a starting balance" do
      account.starting_balance = nil
      expect(account).to be_invalid
    end

    it "has a valid starting balance value" do
      account.starting_balance = "asdf"
      expect(account).to be_invalid
    end

    it "requires last four to be a number" do
      account.last_four = "ASDF"
      expect(account).to be_invalid
    end

    it "requires last four to be exactly 4 characters" do
      account.last_four = "123"
      expect(account).to be_invalid
      account.last_four = "12345"
      expect(account).to be_invalid
    end

    it "does not make last four mandatory" do
      account.last_four = nil
      expect(account).to be_valid
    end

    it "has a valid account type" do
      expect { account.account_type = "randomvalue" }
        .to raise_error(ArgumentError)
        .with_message(/is not a valid account_type/)
    end
  end
end
