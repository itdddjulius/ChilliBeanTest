require 'rails_helper'

RSpec.describe User, :type => :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is valid without a name" do
    user = build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to_not include("can't be blank")
  end

  it "is invalid without an email"do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with a duplicate email" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "test@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "downcases the users email" do
    user = build(:user, email: "TEST@EXAMPLE.COM")
    user.valid?
    expect(user.email).to eq("test@example.com")
  end

  describe "returns a user's name as a string" do
    context "when they have not set a name" do
      it "returns their email address" do
        user = build(:user, name: nil)
        expect(user.fullname).to eq(user.email)
      end
    end

    context "when they have set a name" do
      it "returns their name" do
        user = build(:user)
        expect(user.fullname).to eq(user.name)
      end
    end
  end

  describe "password validation" do
    it "is invalid if the new password is the same as the current password" do
      user = create(:user, email: "test@example.com", password: "YoucaLLthatapa$$word")
      
      user.password = "YoucaLLthatapa$$word"
      user.password_confirmation = "YoucaLLthatapa$$word"
      user.save

      expect(user.errors[:password]).to include("must not be the same as last")
    end

    it "is invalid if less than 8 characters" do
      invalid_user = User.create(email: "test@example.com", password: "123abc")
      expect(invalid_user.errors[:password]).to include("must be at least 8 characters long")

      valid_user = User.create(email: "test@example.com", password: "1234abcd")
      expect(valid_user.errors[:password]).to_not include("must be at least 8 characters long")
    end

    it "is invalid if it does not include at least 1 uppercase character" do
      invalid_user = User.create(email: "test@example.com", password: "123abc")
      expect(invalid_user.errors[:password]).to include("must have at least 1 uppercase character")

      valid_user = User.create(email: "test@example.com", password: "123abC")
      expect(valid_user.errors[:password]).to_not include("must have at least 1 uppercase character")
    end

    it "is invalid if it does not include at least 1 numeric or special character" do
      invalid_user = User.create(email: "test@example.com", password: "ABcdefghij")
      expect(invalid_user.errors[:password]).to include("must have at least 1 numeric character or 1 special (non alphanumeric) character")

      valid_user = User.create(email: "test@example.com", password: "ABcdefghij5")
      expect(valid_user.errors[:password]).to_not include("must have at least 1 numeric character or 1 special (non alphanumeric) character")

      valid_user = User.create(email: "test@example.com", password: "ABcdefghij@")
      expect(valid_user.errors[:password]).to_not include("must have at least 1 numeric character or 1 special (non alphanumeric) character")
    end
  end

  describe "#change_password" do
    before do
      @user = User.create(email: Faker::Internet.email, name: Faker::Name.name, password: "Secureish1")
    end
    context "the existing password is correct" do
      context "the password confirmation matches the new password" do
        it "changes the users password" do
          @user.change_password("Secureish1", "YoucaLLthatapa$$word", "YoucaLLthatapa$$word")
          expect(@user.authenticate("YoucaLLthatapa$$word")).to eq(@user)
        end

        it "returns the user object with no errors" do
          @user.change_password("Secureish1", "YoucaLLthatapa$$word", "YoucaLLthatapa$$word")
          expect(@user.errors).to be_empty
        end
      end
      context "the password confirmation does not match the new password" do
        it "adds an error to the user object" do
          @user.change_password("Secureish1", "securer", "sdfsfs")
          expect(@user.errors[:password_confirmation]).to include("doesn't match Password")
        end

        it "does not change the password" do
          @user.change_password("Secureish1", "securer", "sdfsfs")
          expect(@user.reload.authenticate("securer")).to eq(false)
        end

        it "returns false" do
          expect(@user.change_password("Secureish1", "securer", "sdfsfs")).to eq(false)
        end
      end
      context "the new password is not valid" do
        it "adds an error to the user object" do
          @user.change_password("Secureish1", "s", "s")
          expect(@user.errors[:password]).to include("must be at least 8 characters long")
          expect(@user.errors[:password]).to include("must have at least 1 uppercase character")
          expect(@user.errors[:password]).to include("must have at least 1 numeric character or 1 special (non alphanumeric) character")
        end

        it "does not change the password" do
          @user.change_password("Secureish1", "s", "s")
          expect(@user.reload.authenticate("s")).to eq(false)
        end

        it "returns false" do
          expect(@user.change_password("Secureish1", "s", "s")).to eq(false)
        end
      end
    end
    context "the existing password is not correct" do
      it "adds an error to the user object" do
        @user.change_password("sdfsdf", "securer", "securer")
        expect(@user.errors[:password]).to include("Incorrect")
      end

      it "returns false" do
        expect(@user.change_password("sdfsdf", "securer", "securer")).to eq(false)
      end
    end
  end

  describe "#password_expired?" do
    let(:user) { create(:user) }

    context "the time since user's password_reset_date is greater than PASSWORD_LIFETIME" do
      it "returns true" do
        user.update_attributes(password_reset_date: (User::PASSWORD_LIFETIME + 10).days.ago)

        expect(user.password_expired?).to eq(true)
      end
    end
    context "the time since user's password_reset_date is equal to PASSWORD_LIFETIME" do
      it "returns true" do
        user.update_attributes(password_reset_date: User::PASSWORD_LIFETIME.days.ago)

        expect(user.password_expired?).to eq(true)
      end
    end
    context "the time since user's password_reset_date is less than PASSWORD_LIFETIME" do
      it "returns false" do
        user.update_attributes(password_reset_date: (User::PASSWORD_LIFETIME - 10).days.ago)

        expect(user.password_expired?).to eq(false)
      end
    end
  end
end
