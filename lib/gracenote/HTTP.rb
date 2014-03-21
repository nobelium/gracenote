#
# HTTP class for Gracenote
#
# Used to send get/post request to the webapi
#
require 'net/http'
require 'net/https'
require 'curb'
require 'rack'
require 'uri'

class HTTP
  def self.get(path, cookie='')
    uri = URI(path)
    req = Net::HTTP.new(uri.host, uri.port)
    req.read_timeout = 60
    req.use_ssl = (uri.scheme == "https") ? true : false
    headers = {'Cookie' => cookie}
    
    resp = req.get( uri.path, headers)
    return resp
  end
  
  def self.post(path, data='', cookie='')
    uri = URI(path)
    req = Net::HTTP.new(uri.host, uri.port)
    req.read_timeout = 60
    req.use_ssl = (uri.scheme == "https") ? true : false
    headers = {'Cookie' => cookie, "Content-Type" => "application/xml"}

    if data.class.to_s == 'String'
      reqdata = data;
    else
      reqdata = Rack::Utils.build_nested_query(data)
    end

    resp = req.request_post( uri.path, reqdata, headers)     
    return resp
  end

end
