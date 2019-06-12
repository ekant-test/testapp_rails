class Social
  def initialize(social_token, social_type)
    @social_token = social_token
    @social_type = social_type
  end

  def get_user_social_info
    require 'net/http'
    # uri = URI social_url
    # request = Net::HTTP::Get.new(uri.request_uri)
    # response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https')
    # response
    con = Faraday.new(:url => social_url[0])
    response = con.get do |req|
      req.url social_url[1]
      if @social_type == "linkedin"
        req.headers['x-li-src'] = 'msdk'
        req.headers['Authorization'] = "Bearer #{@social_token}"
      end
    end
    JSON.parse(response.body)
  end

  def social_url
    case @social_type
      when "facebook"
        host = "https://graph.facebook.com"
        path = "/me?fields=id,name,email,birthday,first_name,last_name&access_token=#{@social_token}"
      when "linkedin"
        host = "https://api.linkedin.com"
        path = "/v1/people/~:(id,firstName,lastName,email-address)?format=json"
      when "google"
        host = "https://www.googleapis.com"
        path = "/oauth2/v1/userinfo?access_token=#{@social_token}"
      end
    [host, path]
  end
end