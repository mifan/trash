# coding: utf-8

require 'rubygems'
require 'httparty'
require 'cgi'
require 'uri'
require 'iconv'
#require "active_support"



#get articl list
class TianyaPage

  include HTTParty

  def initialize(username,link)
    @username = username
    @uid = TianyaUID.new(USER_NAME).userid
    @link = link
  end

  def body
    get_response = self.class.get(@link)
    page_context =  Iconv.iconv('UTF-8//IGNORE','GB2312//IGNORE',get_response.body).join('')
    utag  = user_tag
    #puts "[#{page_context}]"
    puts "user tag is: #{utag}"
    indexa = page_context.index(user_tag)
    puts "indexa : #{indexa}"
    file = File.new("test.html", 'w+')
    file.print page_context
    file.flush
    file.close

    indexa
  end

  def encoding
    get_response = self.class.get(@link)
    get_response.headers.inspect
  end

  def user_tag
    "/browse/Listwriter.asp?vid=#{@uid}"
  end


end
