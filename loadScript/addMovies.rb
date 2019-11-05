#!/usr/bin/ruby

require 'csv'
require 'uri'
require 'net/http'
require 'cgi'

def addToDatabase(title, genre, year)
	url = URI("http://localhost:49970/Movies/Create")
	http = Net::HTTP.new(url.host, url.port)

	request = Net::HTTP::Post.new(url)
	request["Host"] = 'localhost:49970'
	request["Connection"] = 'keep-alive'
	request["Content-Length"] = '241'
	request["Cache-Control"] = 'max-age=0'
	request["Origin"] = 'http://localhost:49970'
	request["Upgrade-Insecure-Requests"] = '1'
	request["Content-Type"] = 'application/x-www-form-urlencoded'
	request["User-Agent"] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36'
	request["Sec-Fetch-Mode"] = 'navigate'
	request["Sec-Fetch-User"] = '?1'
	request["Accept"] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3'
	request["Sec-Fetch-Site"] = 'same-origin'
	request["Referer"] = 'http://localhost:49970/Movies/Create,http://localhost:49970/Movies/Create'
	request["Accept-Encoding"] = 'gzip, deflate, br'
	request["Accept-Language"] = 'en-US,en;q=0.9'
	request["Cookie"] = 'eShop=72b2b1b8-a5c7-4d0b-9afd-086b54b07f4f; .AspNet.Consent=yes; .AspNetCore.Antiforgery.ATFdC-SUTrc=CfDJ8N726LSYsMFCjcHyTTQHoCpx0GDmsQqTHbcqueVytrm9vkwKH4Byq-uovZlGteblGmBQnn1Z0VP14IsS9LgpgHJdrDuRSjMpavHV0o7FNmHlOVZTOcWaxLkuJleQwy6WTzryM8lWKr4UGwCyg_PgX5k'


	# prepare body
	urlEncodedTitle = CGI::escape(title)
	urlEncodedGenre = CGI::escape(genre)
	urlEncodedYear = CGI::escape(year)
	urlEncodedPrice = CGI::escape("4.99")
	request.body = "Title=#{urlEncodedTitle}&ReleaseDate=%20#{urlEncodedYear}-10-29&Genre=%20#{urlEncodedGenre}&Price=%20#{urlEncodedPrice}&__RequestVerificationToken=%20CfDJ8N726LSYsMFCjcHyTTQHoCqyKSH4JbBCWrbKlWgI4l2ZeRc52LhUrvC_iwieR8O6HBbZs1Ng4xh5kt6gZUDNyl0zoWaHjTWEo4Bpp0kzhQ-iUdIb1W-lKlVEI-7ne6faCgTzaARo__TfOSUaleq7jaE"
	puts "attempting to add #{title}"
	reqStart = Time.now
	response = http.request(request)
	reqStop = Time.now
	#puts response.read_body
	puts "response code for #{title} was #{response.code}, time for req #{reqStop - reqStart} sec"
	
end

file = CSV.read("trunc_data2.tsv", "r", headers:true, :col_sep => "\t")

file.each { |row|
#	puts row
	title = row['primaryTitle']
	year = row['startYear']
	uncleanedGenre = row['genres']
	genre = uncleanedGenre == "\\N" ? "Drama" : uncleanedGenre.split(',')[0]

	addToDatabase(title, genre, year)
}

