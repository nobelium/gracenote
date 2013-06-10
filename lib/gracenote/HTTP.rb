
module Gracenote
	class HTTP
		def initialize (spec)
			@URL = spec[:url]
			@timeout = spec[:timeout] || 10000
			
		end

		protected
		def prepareREQ
		end

		def sendREQ
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

		end

		def post
			setPOST

		end
	end
end