module Account::UsersHelper
  def is_fresh_account?(user)
    "fresh" if !user.activated
  end
end