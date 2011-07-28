# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SocialCrm::Application.initialize!

if Rails.env == 'production'
  Paperclip.options[:command_path] = "/usr/local/bin" #or whatever folder you need for your production server
end


