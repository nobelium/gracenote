#
# HTTP class for Gracenote
#
# Used to send get/post request to the webapi
#
require 'curb'
require 'rake'

class HTTP
  def self.get(path, data='', cookie='')
    uri = URI(path)
    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = (uri.scheme == "https") ? true : false
    headers = cookie.nil? ? "" : cookie;
    
    if data.class == 'string'
      reqdata = data;
    else
      reqdata = Rack::Utils.build_nested_query(data)
    end
    
    resp = req.get( uri.path, reqdata, headers)
    return resp
  end
  
  def self.post(path, data='', cookie='')
    uri = URI(path)
    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = (uri.scheme == "https") ? true : false
    headers = cookie.nil? ? "" : cookie;

    if data.class == 'string'
      reqdata = data;
    else
      reqdata = Rack::Utils.build_nested_query(data)
    end

    resp = req.request_post( uri.path, reqdata, headers)     
    return resp
  end

end
