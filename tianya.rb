require 'rubygems'

require 'httparty'
require 'cgi'
require 'uri'
require 'pp'


USER_NAME = '铁匠smith'


class TianyaUID
  include HTTParty
  no_follow true
  base_uri 'http://my.tianya.cn/info'

  def initialize(username)
    @username = username
  end

  def userid
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


class TianyaArticle
  include HTTParty
  no_follow true
  base_uri 'http://my.tianya.cn/i/getUserArticleDo.jsp'

  def initialize(username)
    @username = username
    @userid = TianyaUID.new(USER_NAME).userid
  end

  def articles
    get_response = self.class.get('', :query => {:userName => @username, :idWriter => @userid, :type => 4 } )
    get_response.body
  end

end
 
article  = TianyaArticle.new(USER_NAME)
articles = URI.extract(article.articles,'http').uniq

puts articles

