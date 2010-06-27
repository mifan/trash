# coding: utf-8

if RUBY_VERSION < '1.9'
  $KCODE='u'
else
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

require 'rubygems'
require 'httparty'
require 'cgi'
require 'uri'
require 'pp'

dir = Pathname(__FILE__).dirname.expand_path
require dir + 'lib/tianya_uid'
require dir + 'lib/tianya_article'
require dir + 'lib/tianya_page'

USER_NAME = '铁匠smith'
#USER_NAME = '五峰樵夫'
#USER_NAME = '不见得1'
#USER_NAME = '一零二二AX'

article  = TianyaArticle.new(USER_NAME)

max_no = article.max_list_no
puts "max_no:#{max_no}"
(1..max_no).each do |i|
  links = article.page_articles(i)
  puts "page #{max_no}....."
 
  puts "\n"
  sleep 1
  links.each  do |link|
    puts link
    puts TianyaPage.new(USER_NAME,link).body
    break
  end

end

