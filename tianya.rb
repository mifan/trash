require 'rubygems'

require 'httparty'
require 'cgi'
require 'pp'


USER_NAME = '铁匠smith'


class TianyaUID
  include HTTParty
  no_follow true
  base_uri 'http://my.tianya.cn/info'


  def initialize(username)
    @username = username
  end

  def uid
    tempid = 0
    begin
      self.class.get "/#{CGI.escape(USER_NAME)}"
    rescue HTTParty::RedirectionTooDeep => e
      if e.response.key? 'location'
        redirect_location =  e.response.fetch 'location'
        tempid = redirect_location.gsub(/http\:\/\/\w+\.tianya\.cn\//,'').to_i
      end
    rescue
       tempid = -1
    end
    tempid
  end
end


 
tianya_uid = TianyaUID.new(USER_NAME)
puts tianya_uid.uid

