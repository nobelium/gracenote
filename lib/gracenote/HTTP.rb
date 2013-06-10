require 'curb'

module Gracenote
	class HTTP

		attr_accessor :URL , :timeout

		def initialize (spec)
			@URL = spec[:url]
			@timeout = spec[:timeout] || 10000			
		end

		protected
		def prepareREQ
		end

		def sendREQ
			if @type == "GET"
				return sendGET
			elsif @type == "POST"
				return sendPOST
			end
		end

		def sendGET 
			c = Curl::Easy.new(@URL)
			c.perform
			return c.body_str
		end

		def sendPOST
			c = Curl::Easy.new(@URL)
			c.http_post ()
			return c.body_str
		end

		def setGET
			@type = "GET"
		end

		def setPOST
			@type = "POST"
		end

		public
		def get
			setGET
			sendREQ
		end

		def post
			setPOST
			sendREQ
		end
	end
end