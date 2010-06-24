require 'rubygems'

require 'httparty'
require 'cgi'
require 'uri'
require 'pp'


#USER_NAME = '铁匠smith'
USER_NAME = '五峰樵夫'
#USER_NAME = '不见得1'


#Retrive User ID form tianya
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

#get 
class TianyaArticle
  include HTTParty
  no_follow true
  base_uri 'http://my.tianya.cn/i/getUserArticleDo.jsp'
  #last url: http://my.tianya.cn/i/getUserArticleDo.jsp?userName=%E9%93%81%E5%8C%A0smith&url=http://m.www.bbs.hk.ty/feeds/apps/my/pubReply/9870517/937.shtml&type=4

  def initialize(username)
    @username = username
    @userid = TianyaUID.new(USER_NAME).userid
  end

  def page_articles(page_no)
    get_response = self.class.get('', :query => {:userName => @username, :url => "http://m.www.bbs.hk.ty/feeds/apps/my/pubReply/#{@userid}/#{page_no}.shtml", :type => 4 } )

    URI.extract(get_response.body,'http').uniq.delete_if do |a|
      (/^http\:\/\/\w+\.tianya\.cn\/publicforum\/content/ =~ a) == nil
    end

  end

  def recent_articles(date = nil)
    get_response = self.class.get('', :query => {:userName => @username, :idWriter => @userid, :type => 4 } )

    URI.extract(get_response.body,'http').uniq.delete_if do |a|
      (/^http\:\/\/\w+\.tianya\.cn\/publicforum\/content/ =~ a) == nil
    end

  end




  def max_list_no
    get_response = self.class.get('', :query => {:userName => @username, :idWriter => @userid, :type => 4 } )

    page_links = URI.extract(get_response.body,'http').uniq.delete_if do |a|
      (/^http\:\/\/m\.www\.bbs\.hk\.ty\/feeds\/apps\/my\/pubReply/ =~ a) == nil
    end

    page_links_no = page_links.collect do |l|
      l.split("/#{@userid}\/").last.split('.').first.to_i
    end
    page_links_no.sort.last
  end


  def all_article_links
     list_no = max_list_no

    
  end

end





 
article  = TianyaArticle.new(USER_NAME)


max_no = article.max_list_no
puts "max_no:#{max_no}"
(1..max_no).each do |i|
  links = article.page_articles(max_no-i+1)
  puts "page #{max_no-i+1}....."
  puts links
  puts "\n"
  sleep 1
end

