class User < ActiveRecord::Base
  acts_as_authentic

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end

  class << self
    def find_by_login_or_email(val)
      find_by_login(val) || find_by_email(val)
    end
  end # class << self
end
