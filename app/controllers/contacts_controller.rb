class ContactsController < BaseController
  require 'linkedin'
  layout "application", :except => [:new]

  def index
    client = LinkedIn::Client.new("qfnqhyc4s22w", "9ArLP4SgyOjrBBG2")
    request_token = client.request_token(:oauth_callback => "http://#{request.host_with_port}/contacts/new")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret
    redirect_to client.request_token.authorize_url
  end

  def new
    get_access_from_linkedin

    #Profile Page of the User
    #url = "http://api.linkedin.com/v1/people/~"
    #resp, content = access_token.get(url)
    #Rails.logger.info("Response =>  #{resp} | Content => #{content}")

    @profile = @client.profile
    @connections = @client.connections
    @friends = []
    parse_friends(@connections)
    mail_id = ""
    @friends.each do |f|
      if f.include?("Hemant")
        mail_id = f.split('|')[1]
      end
    end
    mail_id = mail_id.strip.delete "\"" "]" "["
    Rails.logger.info("ID => => => #{mail_id}")
    session[:friends] = @friends
    #making use of Messaging API
    #path = "http://api.linkedin.com/v1/people/~/mailbox"
    #message = "<?xml version='1.0' encoding='UTF-8'?> <mailbox-item> <recipients> <recipient><person path='/people/~'/> </recipient><recipient><person path=\"/people/#{mail_id}\" /></recipient></recipients><subject>Congratulations on your new position.</subject> <body>You're certainly the best person for the job!</body> </mailbox-item>"
    #resp, content = access_token.post(path, message, {'Content-Type' => 'application/xml'})
    #Rails.logger.info("Response =>  #{resp} | Content => #{content}")
    

    #Rails.logger.info("#{@connections.inspect}")
  end

  def get_access_from_linkedin
    @client = LinkedIn::Client.new("qfnqhyc4s22w", "9ArLP4SgyOjrBBG2")
    pin = params[:oauth_verifier]
    atoken, asecret = @client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
    session[:atoken] = atoken
    session[:asecret] = asecret
    @client.authorize_from_access(session[:atoken], session[:asecret])

    consumer = OAuth::Consumer.new("qfnqhyc4s22w", "9ArLP4SgyOjrBBG2")
    @access_token = OAuth::AccessToken.new(consumer, session[:atoken], session[:asecret])
  end

  def parse_friends(connections)
    firstname = nil
    lastname = nil
    contact_id = nil
    connections.each do |raw_data|
      raw_data.each do |array_data|
        if array_data.kind_of?(Array)
          array_data.each do |contacts_data|
            contacts_data.each do |actual_data|
              if actual_data.to_s.include?('first_name')
                firstname = actual_data.to_s.split(',')[1].chomp
              end
              if actual_data.to_s.include?('last_name')
                lastname = actual_data.to_s.split(',')[1].chomp
              end
              if actual_data.to_s.include?('id')
                contact_id = actual_data.to_s.split(',')[1].chomp
              end
            end
            @friends << firstname.to_s + lastname.to_s + "|" + contact_id.to_s
          end
        end
      end
    end
  end

  def send_messages_to_connections
    consumer = OAuth::Consumer.new("qfnqhyc4s22w", "9ArLP4SgyOjrBBG2")
    @access_token = OAuth::AccessToken.new(consumer, session[:atoken], session[:asecret])
    subject = "Invitation to Collaborate"
    body = "It is of great pleasure to invite you to Collaborate for discussions and for sharing blogs, pictures, videos for the welfare of our business growth."
    selected_contacts = []
    selected_names = []

    @friends = session[:friends]

    @friends.each do |contact|
      contact = contact.strip.delete "\"" "]" "["
      if params.include?(contact.strip.split('|')[0])
        selected_contacts << contact.split('|')[1].strip
        selected_names << contact.split('|')[0].strip
      end
    end
    Rails.logger.info("SC   =>  #{selected_contacts}")
    recipients = ""
    selected_contacts.each do |c|
      recipients+= "<recipient><person path=\"/people/#{c}\" /></recipient>"
    end
    Rails.logger.info("SC   =>  #{recipients}")
    #making use of Messaging API
    path = "http://api.linkedin.com/v1/people/~/mailbox"
    message = "<?xml version='1.0' encoding='UTF-8'?> <mailbox-item> <recipients> <recipient><person path='/people/~'/> </recipient>#{recipients}</recipients><subject>#{subject}</subject> <body>#{body}</body> </mailbox-item>"
    resp, content = @access_token.post(path, message, {'Content-Type' => 'application/xml'})
    Rails.logger.info("Response =>  #{resp} | Content => #{content}")

    redirect_to home_url, :notice => "Invitations sent to #{selected_names.to_s}"
  end
  
end
