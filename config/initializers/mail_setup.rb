ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'localhost',
  :user_name            => 'collaborate.mailer',
  :password             => 'c0llab0rate',
  :authentication       => 'plain',
  :enable_starttls_auto => true  
}
ActionMailer::Base.default_url_options[:host] = "50.19.105.161"
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
