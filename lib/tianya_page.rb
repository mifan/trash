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
    page_context =  Iconv.iconv('UTF-8//IGNORE','GB2312//IGNORE',get_response.body).join()
    utag  = user_tag
    #puts "[#{page_context}]"
    puts "user tag is: #{utag}"
    seek_index = 0

    while index_user = page_context.index(user_tag,seek_index)
      puts "index_user:[#{index_user}]"
      seek_index = index_user + user_tag.length
      name_begin_tag = "target=_blank>"
      name_end_tag = "</a>"
      user_name_index_begin = page_context.index(name_begin_tag,seek_index)
      if user_name_index_begin
        user_name_index_end =  page_context.index(name_end_tag, user_name_index_begin + name_begin_tag.length )
	if user_name_index_end
	  user_name = page_context[user_name_index_begin + name_begin_tag.length, user_name_index_end - (user_name_index_begin + name_begin_tag.length)]
	  puts "find user name:#{Iconv.iconv('GB2312//IGNORE','UTF-8//IGNORE',user_name)}"
          date_begin_index = page_context.index("-",user_name_index_end+name_end_tag.length)
          #find date
	  if date_begin_index
	   date_end_tag = "</font>"
           date_end_index = page_context.index(date_end_tag,date_begin_index+1)
	   if date_end_index
	     date_begin_index = date_begin_index -4
	     post_date = page_context[date_begin_index, date_end_index - date_begin_index]
             puts "posted @ #{Iconv.iconv('GB2312//IGNORE','UTF-8//IGNORE',post_date)}"
             #find what he said
	     context_begin_tag = "</table>"
             context_begin_index = page_context.index(context_begin_tag,date_end_index+date_end_tag.length)
	     if context_begin_index
	       context_end_tag = "<TABLE"
               context_end_index = page_context.index(context_end_tag,context_begin_index+context_begin_tag.length)
	       if context_end_index
	         context_say = page_context[context_begin_index+context_begin_tag.length, context_end_index - (context_begin_index+context_begin_tag.length)]
                 puts "said : #{Iconv.iconv('GB2312//IGNORE','UTF-8//IGNORE',context_say)}"
	       end
	     end

	   end
	  end


	end
        
      end

    end

    file = File.new("test.html", 'w+')
    file.print page_context
    file.flush
    file.close

    index_user
  end

  def encoding
    get_response = self.class.get(@link)
    get_response.headers.inspect
  end

  def user_tag
    "/browse/Listwriter.asp?vid=#{@uid}"
  end


end
