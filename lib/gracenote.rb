require "gracenote/version"
require "gracenote/HTTP"

class Gracenote << HTTP
  def initialize (spec)
    if(spec[:clientID].nil? || !(defined spec[:clientID] || spec[:clientID] == "")) 
      p "clientID cannot be nil"
      return
    end
    if(spec[:clientTag].nil? || !(defined spec[:clientTag] || spec[:clientTag] == ""))
      p "clientTag cannot be nil"
    end
    
    @clientID = spec[:clientID]
    @clientTag = spec[:clientTag]
    @userID = spec[:userID]
    @apiURL = "https://" + @clientID + ".web.cddbp.net/webapi/xml/1.0/"
  end
  
  public 
  def registerUser (clientID = nil)
    if(clientID.nil?)
      clientID = @clientID + "-" + @clientTag
    end
    
    if(!(@userID.nil?) || defined @userID)
      p "user already registered. No need to register again"
      return @userID
    end
    #send req to server and get user ID
    return @userID
  end
  
  def findTrack
  end
  
  def findAlbum
  end
  
  def findArtist
  end
  
  protected
  #execute a query on gracenote webapi
  def api (query)
    
  end
  
  def constructQueryReq
    #construct the XML query
  end
  
  def constructQueryBody
  end
  
  def checkRES
  end
  
  def parseRES
  end
  
end

