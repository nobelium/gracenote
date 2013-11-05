#
# HTTP class for Gracenote
#
# Used to send get/post request to the webapi
#
require 'rack'
require 'curb'
require 'timeout'

class HTTP
  @timeout = 10

  def self.get(path)
    
    resp = nil
    Timeout.timeout @timeout do
      resp = Curl.get(path)
    end

    resp
  end
  
  def self.post(path, data='')
    headers = {"Content-Type" => "application/xml"}

    if data.class.to_s == 'String'
      reqdata = data;
    else
      reqdata = Rack::Utils.build_nested_query(data)
    end

    resp = nil
    Timeout.timeout @timeout do
      resp = Curl.post(path, reqdata)
    end

    resp
  end

end
