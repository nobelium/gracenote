require_relative "gracenote/HTTP"
require "crack"

class Gracenote

  # class variables
  @@ALL_RESULTS = '1'
  @@BEST_MATCH_ONLY = '0'

  # Function: initialize
  # Sets the following instance variables
  #   clientID
  #   clientTag
  #   userID
  #   apiURL
  def initialize (spec)
    if(spec[:clientID].nil? || spec[:clientID] == "") 
      raise "clientID cannot be nil"
    end
    if(spec[:clientTag].nil? || spec[:clientTag] == "")
      raise "clientTag cannot be nil"
    end
    
    @clientID = spec[:clientID]
    @clientTag = spec[:clientTag]
    @userID = spec[:userID].nil? ? nil : spec[:userID]
    @apiURL = "https://c" + @clientID + ".web.cddbp.net/webapi/xml/1.0/"
  end
  
  # public methods
  public 

  # Function: registerUser 
  # Registers a user and returns userID
  def registerUser (clientID = nil)
    if(clientID.nil?)
      clientID = @clientID + "-" + @clientTag
    end
    
    if not @userID.nil?
      p "user already registered. No need to register again"
      return @userID
    end

    #send req to server and get user ID
    data =  "<QUERIES>
  <QUERY CMD=\"REGISTER\">
    <CLIENT>"+ clientID +"</CLIENT>
  </QUERY>
</QUERIES>"

    resp = HTTP.post(@apiURL, data)
    puts resp

    resp = checkRES resp
    @userID = resp['RESPONSES']['RESPONSE']['USER']

    puts resp
    puts @userID

    return @userID
  end
  
  # Function: findTrack 
  # Finds a track
  # Arguments:
  #   artistName
  #   albumTitle
  #   trackTitle
  #   matchMode
  def findTrack(artistName, albumTitle, trackTitle, matchMode = @@ALL_RESULTS)
    if @userID == nil 
      registerUser
    end
    body = constructAlbumQueryBody(artistName, albumTitle, trackTitle, "", "ALBUM_SEARCH", matchMode)
    data = constructQueryReq(body)
    resp = HTTP.post(@apiURL, data)
    resp = checkRES resp

    symbolize(resp["RESPONSES"])
  end
  
  # Function: findArtist 
  # Finds a Artist
  # Arguments:
  #   artistName
  #   matchMode
  def findArtist(artistName, matchMode = @@ALL_RESULTS)
    return findTrack(artistName, "", "", matchMode)
  end

  # Function: findAlbum
  # finds an Album
  # Arguments:
  #   artistName
  #   albumTitle
  #   trackTitle
  #   matchMode  
  def findAlbum(artistName, albumTitle, matchMode = @@ALL_RESULTS)
    return findTrack(artistName, albumTitle, "", matchMode)
  end
  
  # Function: albumToc
  # Fetches album metadata based on a table of contents.
  # Arguments:
  #   toc
  def albumToc(toc)
    if @userID == nil 
      registerUser
    end
    body = "<TOC><OFFSETS>" + toc + "</OFFSETS></TOC>"
    data = constructAlbumQueryBody(body, "ALBUM_TOC")
    resp = HTTP.post(@apiURL, data)
    resp = checkRES resp

    symbolize(resp["RESPONSES"])
  end

  # Function: fetchOETData
  # Gets data based on gn_id
  # Arguments:
  #   gn_id
  def fetchOETData(gn_id)
    if @userID == nil 
      registerUser
    end

    body = "<GN_ID>" + gn_id + "</GN_ID>
              <OPTION>
                <PARAMETER>SELECT_EXTENDED</PARAMETER>
                  <VALUE>ARTIST_OET</VALUE>
              </OPTION>
              <OPTION>
                <PARAMETER>SELECT_DETAIL</PARAMETER>
                  <VALUE>ARTIST_ORIGIN:4LEVEL,ARTIST_ERA:2LEVEL,ARTIST_TYPE:2LEVEL</VALUE>
              </OPTION>"

    data = constructQueryReq(body, "ALBUM_FETCH")
    resp = HTTP.post(@apiURL, data)
    resp = checkRES resp

    symbolize(resp["RESPONSES"])
  end

  # Function: fetchSeason
  # Fetch details for a season based on gn_id
  # Arguments:
  #   gn_id
  def fetchSeason(gn_id)
    if @userID == nil 
      registerUser
    end

    body = "<GN_ID>" + gn_id + "</GN_ID>"

    data = constructQueryReq(body, "SEASON_FETCH")
    resp = HTTP.post(@apiURL, data)
    resp = checkRES resp

    symbolize(resp["RESPONSES"]["RESPONSE"]["SEASON"])
  end

  # Function: findTVShow
  # Searches for TV shows matching text
  # Arguments:
  #   text
  def findTVShow(text)
    if @userID == nil 
      registerUser
    end

    body = "<TEXT TYPE='TITLE'>" + text + "</TEXT>
  <MODE>SINGLE_BEST</MODE>
  <OPTION>
    <PARAMETER>SELECT_EXTENDED</PARAMETER>
    <VALUE>IMAGE</VALUE>
  </OPTION>"

    data = constructQueryReq(body, "SERIES_SEARCH")
    resp = HTTP.post(@apiURL, data)
    resp = checkRES resp

    symbolize(resp["RESPONSES"]["RESPONSE"])
  end

  # Function: fetchContributor
  # Fetch details for a contributor based on gn_id
  # Arguments:
  #   gn_id
  def fetchContributor(gn_id)
    if @userID == nil 
      registerUser
    end

    body = "<GN_ID>" + gn_id + "</GN_ID>
  <OPTION>
    <PARAMETER>SELECT_EXTENDED</PARAMETER>
    <VALUE>IMAGE,MEDIAGRAPHY_IMAGES</VALUE>
  </OPTION>"

    data = constructQueryReq(body, "CONTRIBUTOR_FETCH")
    resp = HTTP.post(@apiURL, data)
    resp = checkRES resp

    symbolize(resp["RESPONSES"]["RESPONSE"]["CONTRIBUTOR"])
  end

  # Function: findContributor
  # Searches for contributor matching text
  # Arguments:
  #   text
  def findContributor(text)
    if @userID == nil 
      registerUser
    end

    body = "<TEXT TYPE='NAME'>" + text + "</TEXT>
  <MODE>SINGLE_BEST</MODE>
  <OPTION>
    <PARAMETER>SELECT_EXTENDED</PARAMETER>
    <VALUE>IMAGE,MEDIAGRAPHY_IMAGES</VALUE>
  </OPTION>"

    data = constructQueryReq(body, "CONTRIBUTOR_SEARCH")
    resp = HTTP.post(@apiURL, data)
    resp = checkRES resp

    symbolize(resp["RESPONSES"]["RESPONSE"])
  end

  # Function: fetchTVShow
  # Fetch details for a show based on gn_id
  # Arguments:
  #   gn_id
  def fetchTVShow(gn_id)
    if @userID == nil 
      registerUser
    end

    body = "<GN_ID>" + gn_id + "</GN_ID>"

    data = constructQueryReq(body, "SERIES_FETCH")
    resp = HTTP.post(@apiURL, data)
    resp = checkRES resp

    symbolize(resp["RESPONSES"]["RESPONSE"]["SERIES"])
  end
  
  # protected methods
  protected

  # Function: symbolize
  # normalize a response
  def symbolize(obj)
      return obj.inject({}){|memo,(k,v)| memo[k.downcase.to_sym] =  symbolize(v); memo} if obj.is_a? Hash
      return obj.inject([]){|memo,v    | memo << symbolize(v); memo} if obj.is_a? Array
      return obj
  end
  
  # Function: constructQueryReq
  # Constructs Query
  # Arguments:
  #   body
  #   command
  def constructQueryReq(body, command = "ALBUM_SEARCH")
    #construct the XML query
    return  "<QUERIES>
                <AUTH>
                    <CLIENT>"+ @clientID + "-" + @clientTag + "</CLIENT>
                    <USER>"+ @userID + "</USER>
                </AUTH>
                <QUERY CMD=\"" + command + "\">
                    " + body + "
                </QUERY>
            </QUERIES>"
  end
  
  # Function: constructAlbumQueryBody
  # Constructs query body
  # Arguments:
  #   artist
  #   album
  #   track
  #   gn_id
  #   command
  #   matchMode
  def constructAlbumQueryBody(artist, album, track, gn_id, command = "ALBUM_SEARCH", matchMode = @@ALL_RESULTS)
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
  
  # Function: checkRES
  # Checks an XML response and converts it into json
  # Arguments:
  #   resp
  def checkRES resp
    if resp.status != '200'
      #raise "Problem!! Got #{resp.code} with #{resp.message}"
    end
    json = nil
    begin
      json = Crack::XML.parse resp.body_str
    rescue Exception => e
      raise e
    end

    status = json['RESPONSES']['RESPONSE']['STATUS'].to_s
    case status
      when "ERROR"
        raise "ERROR in response"
      when "NO_MATCH"
        raise "No match found"
      else
        if status != "OK"
          raise "Problems found in the response"
        end
     end 
    return json
  end
end