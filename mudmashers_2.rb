require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'nikkou'

def osascript(script)
  system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
end

def get_paged_links(user,last_page)
	@base_uri = "https://thepiratebay.org/user/#{user}/"
	@page_links=[]
	(0..last_page).each {|i| @page_links.push("#{@base_uri}#{i}/3")}
	return @page_links
end

def get_magnet_links(uri)
	res = RestClient.get(uri)
	page = Nokogiri::HTML(res)
	@single_page_magnet_links = page.search('a').attr_includes('href','magnet').map {|value| value["href"].sub(/&.*$/,"")}
	return @single_page_magnet_links
end

def transmission_add(array)
	array.each do |x|
		system("open", x)
		sleep(1)
		osascript <<-END
		repeat 2 times
		delay 1
		tell applications "System Events" 
		keystroke return
		end tell
		end repeat
	END
	end
end

@magnet_links = []
get_paged_links("mudmashers",33).each {|x| @magnet_links.push(get_magnet_links(x))}
puts @magnet_links

