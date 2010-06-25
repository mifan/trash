require 'rubygems'
require 'httparty'
require 'cgi'
require 'uri'
require 'pp'


dir = Pathname(__FILE__).dirname.expand_path
require dir + 'lib/tianya_uid'
require dir + 'lib/tianya_article'

USER_NAME = '铁匠smith'
#USER_NAME = '五峰樵夫'
#USER_NAME = '不见得1'

article  = TianyaArticle.new(USER_NAME)

max_no = article.max_list_no
puts "max_no:#{max_no}"
(max_no..max_no).each do |i|
  links = article.page_articles(max_no-i+1)
  puts "page #{max_no}....."
 
  puts "\n"
  sleep 1
  links.each  do |link|
    puts link
  end

end

