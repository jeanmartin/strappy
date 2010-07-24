class Notifier < ActionMailer::Base
  layout false
  default_url_options[:host] = SiteConfig.host_name
  default :from => "#{SiteConfig.app_name} Notifier <#{SiteConfig.email_from}>"

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => user.email, :subject  => "Password Reset Instructions")
  end

end