module NexmoTts
	require "open-uri"
	require "net/https"
	require "json"

	class Client
		def initialize(key = ENV['NEXMO_API_KEY'], secret = ENV['NEXMO_API_SECRET'])
				@api_secret = secret
				@api_key = key
		end
		#mode is for deciding whether it is a tts, a tts-prompt or a call
		#the response method sets the response type required from Nexmo when the client sends the request
		attr_accessor :mode, :response_method
		def call(options)
			options[:api_key] = @api_key
			options[:api_secret] = @api_secret
			request = parameterize(options)
			mode(options[:mode])
			response_method(options[:response_method])
			request_string = "https://rest.nexmo.com/#{@mode}/#{@response_method}?#{request}" #generating the request string
			begin
				#parsing the request string and set the necessary options for sending the reqest
				uri = URI.parse(request_string)
				http = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = true
				http.verify_mode = OpenSSL::SSL::VERIFY_NONE
				request = Net::HTTP::Get.new(uri.request_uri)
				response_unparsed = http.request(request)
				response(response_unparsed) #parse the data received from nexmo]
			rescue SocketError => e 
				"Internet connection error"
			end	
		end
		private
			def response(data)
				if @response_method == "json" #parse the response if it is JSON. If Nexmo returns and error code the display the error text otherwise return the JSON variable
					parsed = JSON.parse(data.body)
					if parsed["status"] != "0"
						parsed["error-text"]
					else
						parsed
					end
				else
					data
				end
			end
			def parameterize(options)
	  			URI.escape(options.collect{|k,v| "#{k}=#{v}"}.join('&')) #convert the hash to a query for the request string
			end
			def mode(opt_mode)
				if opt_mode=="tts-prompt"
					@mode = "tts-prompt"
				else
					@mode = "tts"
				end
			end
			def response_method(opt_method)
				if opt_method=="xml"
					@response_method = "xml"
				else
					@response_method = "json"
				end
			end
	end
end