require 'rubygems'
require 'httparty'
require 'cgi'
require 'uri'


#get articl list
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




 
