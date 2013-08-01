require "gracenote/version"
require "gracenote/HTTP"

class Gracenote
  def initialize (spec)
    @@ALL_RESULTS = 1
    @@BEST_MATCH_ONLY = 0
    if(spec[:clientID].nil? || !(defined spec[:clientID] || spec[:clientID] == "")) 
      raise "clientID cannot be nil"
    end
    if(spec[:clientTag].nil? || !(defined spec[:clientTag] || spec[:clientTag] == ""))
      raise "clientTag cannot be nil"
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
    
    if !(@userID.nil?) || defined? @userID
      p "user already registered. No need to register again"
      return @userID
    end

    #send req to server and get user ID
    data =  "<QUERIES>
              <QUERY CMD=\"REGISTER\">
                <CLIENT>"+ @clientID +"</CLIENT>
              </QUERY>
            </QUERIES>";
    resp = HTTP.get(@apiURL, data)
    resp = parseRES esp
    @userID = resp['RESPONSE'][:USER]

    return @userID
  end
  
  def findTrack(artistName, albumTitle, trackTitle, matchMode = @@ALL_RESULTS)
    if @userID == nil 
      registerUser()
    end
    body = constructQueryBody(artistName, albumTitle, trackTitle, "", "ALBUM_SEARCH", matchMode)
    data = constructQueryReq(body)
    return api(data);
  end
  
  def findArtist(artistName, matchMode = @@ALL_RESULTS)
    return findTrack(artistName, "", "", matchMode)
  end
  
  def findAlbum(artistName, albumTitle, matchMode = @@ALL_RESULTS)
    return findTrack(artistName, albumTitle, "", matchMode)
  end
  
  protected
  #execute a query on gracenote webapi
  def api (query)
    
  end
  
  def constructQueryReq(body, command = "ALBUM_SEARCH")
    #construct the XML query
    return  "<QUERIES>
                <AUTH>
                    <CLIENT>"+ @clientID + "-" + @clientTag + "</CLIENT>
                    <USER>"+ @userID + "</USER>
                </AUTH>
                <QUERY CMD=\"" + @command + "\">
                    "+ @body + "
                </QUERY>
            </QUERIES>"
  end
  
  def constructQueryBody(artist, album, track, gn_id, command = "ALBUM_SEARCH", matchMode = @@ALL_RESULTS)
    body = ""
    # If a fetch scenario, user the Gracenote ID.
    if command == "ALBUM_FETCH"
            body += "<GN_ID>" + gn_id + "</GN_ID>"
    else
      # Otherwise, just do a search.
      # Only get the single best match if that's what the user wants.
      if matchMode == @@BEST_MATCH_ONLY
        body += "<MODE>SINGLE_BEST_COVER</MODE>" 
      end
      # If a search scenario, then need the text input
      if artist != "" 
        body += "<TEXT TYPE=\"ARTIST\">" + artist + "</TEXT>"
      end
      if track != "" 
        body += "<TEXT TYPE=\"TRACK_TITLE\">" + track + "</TEXT>"
      end
      if album != "" 
        body += "<TEXT TYPE=\"ALBUM_TITLE\">" + album + "</TEXT>"
      end
    end
    # Include extended data.
    
    body += "<OPTION>
              <PARAMETER>SELECT_EXTENDED</PARAMETER>
              <VALUE>COVER,REVIEW,ARTIST_BIOGRAPHY,ARTIST_IMAGE,ARTIST_OET,MOOD,TEMPO</VALUE>
            </OPTION>"

    # Include more detailed responses.
    body += "<OPTION>
              <PARAMETER>SELECT_DETAIL</PARAMETER>
              <VALUE>GENRE:3LEVEL,MOOD:2LEVEL,TEMPO:3LEVEL,ARTIST_ORIGIN:4LEVEL,ARTIST_ERA:2LEVEL,ARTIST_TYPE:2LEVEL</VALUE>
            </OPTION>"

    # Only want the thumbnail cover art for now (LARGE,XLARGE,SMALL,MEDIUM,THUMBNAIL)
    body += "<OPTION>
              <PARAMETER>COVER_SIZE</PARAMETER>
              <VALUE>MEDIUM</VALUE>
            </OPTION>"

    return body
  end
  
  def checkRES resp
    xml = nil
    begin
      xml = Ox.parse_obj resp
    rescue Exception => e
      raise e
    end

    status = xml['RESPONSE'][:status]
    case status
    when 'ERROR'
      raise  'XML PARSE ERROR'
    when 'NO_MATCH'
      raise 'XML NO MATCH FOUND'
    else 
      if status != 'OK'
        raise 'STATUS NOT OK'
      end 
    end

    return xml
  end
  
  def parseRES resp
    begin
      xml = checkRES resp
    rescue Exception => e
      raise e
    end

    output = Array.new
    xml.each do |resp|
      obj = Hash.new
      output << obj
    end

    return output
  end
  
end