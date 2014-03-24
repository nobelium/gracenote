require "gracenote/HTTP"
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
              <QUERY CMD='REGISTER'>
                <CLIENT>"+ clientID +"</CLIENT>
              </QUERY>
            </QUERIES>"
    resp = api(data)
    resp = checkRES resp
    @userID = resp['RESPONSES']['RESPONSE']['USER']

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
    data = api(constructQueryReq(body))
    return parseAlbumRES(data);
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
    return parseAlbumRES(data)
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
    resp = api(data)
    resp = checkRES resp
    
    json = resp["RESPONSES"]

    output = Array.new()
    output[:artist_origin] = json["RESPONSE"]["ALBUM"]["ARTIST_ORIGIN"].nil? ? "" : _getOETElem(json["RESPONSE"]["ALBUM"]["ARTIST_ORIGIN"]) 
    output[:artist_era]    = json["RESPONSE"]["ALBUM"]["ARTIST_ERA"].nil? ? "" : _getOETElem(json["RESPONSE"]["ALBUM"]["ARTIST_ERA"])
    output[:artist_type]   = json["RESPONSE"]["ALBUM"]["ARTIST_TYPE"].nil? ? "" : _getOETElem(json["RESPONSE"]["ALBUM"]["ARTIST_TYPE"])
    return output
  end
  
  # TVShow methods

  # Function: fetchSeason
  # Fetches details of a season from gn_id
  # Arguments:
  #   gn_id
  def fetchSeason (gn_id)
    if @userID == nil 
      registerUser
    end

    body = "<GN_ID>" + gn_id + "</GN_ID>"
    data = constructQueryReq(body, "SEASON_FETCH")

    resp = api(data)
    return checkRES(resp)
  end

  # Function: fetchTVShow
  # Fetches details of TV Show from gn_id
  # Arguments:
  #   gn_id
  def fetchTVShow (gn_id)
    if @userID == nil 
      registerUser
    end

    body = "<GN_ID>" + gn_id + "</GN_ID>
              <OPTION>
                <PARAMETER>SELECT_EXTENDED</PARAMETER>
                <VALUE>IMAGE</VALUE>
              </OPTION>"

    data = constructQueryReq(body, "SERIES_FETCH")

    resp = api(data)
    return checkRES(resp)
  end

  # Function: findTVShow
  # Finds TVShows which matches the name
  # Arguments:
  #   name
  #   single
  def findTVShow (name, single=true)
    if @userID == nil 
      registerUser
    end

    singleText = single ? '<MODE>SINGLE_BEST</MODE>' : ''
  
    body = "<TEXT TYPE='TITLE'>" + name + "</TEXT>
            " + singleText + "
            <OPTION>
              <PARAMETER>SELECT_EXTENDED</PARAMETER>
              <VALUE>IMAGE</VALUE>
            </OPTION>"

    data = constructQueryReq(body, "SERIES_SEARCH")

    resp = api(data)
    return checkRES(resp)
  end

  # Function: fetchContributor
  # Fetches details of a contributor from gn_id
  # Arguments:
  #   gn_id
  def fetchContributor (gn_id)
    if @userID == nil 
      registerUser
    end

    body = "<GN_ID>" + gn_id + "</GN_ID>
            <OPTION>
              <PARAMETER>SELECT_EXTENDED</PARAMETER>
              <VALUE>IMAGE,MEDIAGRAPHY_IMAGES</VALUE>
            </OPTION>"

    data = constructQueryReq(body, "CONTRIBUTOR_FETCH")

    resp = api(data)
    return checkRES(resp)
  end

  # Function: findContributor
  # Find details of a contributor from name
  # Arguments:
  #   name
  def findContributor (name)
    if @userID == nil 
      registerUser
    end

    body = "<TEXT TYPE='NAME'>" + name + "</TEXT>
              <MODE>SINGLE_BEST</MODE>
            <OPTION>
              <PARAMETER>SELECT_EXTENDED</PARAMETER>
              <VALUE>IMAGE,MEDIAGRAPHY_IMAGES</VALUE>
            </OPTION>"

    data = constructQueryReq(body, "CONTRIBUTOR_SEARCH")
    
    resp = api(data)
    return checkRES(resp)
  end

  ###################################################### protected methods ######################################################
  protected
  # Function: api
  # execute a query on gracenote webapi
  # Arguments:
  #   query
  def api (query)
    return HTTP.post(@apiURL, query)
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
    if resp.code.to_s != '200'
      raise "Problem!! Got #{resp.code} with #{resp.message}"
    end
    json = nil
    begin
      json = Crack::XML.parse resp.body
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
  
  # Function: parseAlbumRES
  # Parse's an XML response
  # Arguments:
  #   resp
  def parseAlbumRES resp
    json = nil
    begin
      json = checkRES resp
    rescue Exception => e
      raise e
    end
    output = Array.new
    data = Array.new
    if json['RESPONSES']['RESPONSE']['ALBUM'].class.to_s != 'Array'
      data.push json['RESPONSES']['RESPONSE']['ALBUM']
    else 
      data = json['RESPONSES']['RESPONSE']['ALBUM']
    end
    
    data.each do |a|
      obj = Hash.new 
      
      obj[:album_gnid]         = a["GN_ID"].to_i
      obj[:album_artist_name]  = a["ARTIST"].to_s
      obj[:album_title]        = a["TITLE"].to_s
      obj[:album_year]         = a["DATE"].to_s
      obj[:genre]              = _getOETElem(a["GENRE"])
      obj[:album_art_url]      = _getAttribElem(a["URL"], "TYPE", "COVERART")

      # Artist metadata
      obj[:artist_image_url]  = _getAttribElem(a["URL"], "TYPE", "ARTIST_IMAGE")
      obj[:artist_bio_url]    = _getAttribElem(a["URL"], "TYPE", "ARTIST_BIOGRAPHY")
      obj[:review_url]        = _getAttribElem(a["URL"], "TYPE", "REVIEW")

      # If we have artist OET info, use it.
      if not a["ARTIST_ORIGIN"].nil?
        obj[:artist_era]    = _getOETElem(a["ARTIST_ERA"])
        obj[:artist_type]   = _getOETElem(a["ARTIST_TYPE"])
        obj[:artist_origin] = _getOETElem(a["ARTIST_ORIGIN"])
      else
      # If not available, do a fetch to try and get it instead.
        obj = merge_recursively(obj, fetchOETData(a["GN_ID"]) )
      end

      # Parse track metadata if there is any.
      obj[:tracks] = Array.new()
      tracks = Array.new()
      if a["TRACK"].class.to_s != 'Array'
        tracks.push a["TRACK"]
      else 
        tracks = a["TRACK"]
      end
      tracks.each do |t|
        track = Hash.new()

        track[:track_number]      = t["TRACK_NUM"].to_s
        track[:track_gnid]        = t["GN_ID"].to_s
        track[:track_title]       = t["TITLE"].to_s
        track[:track_artist_name] = t["ARTIST"].to_s

        # If no specific track artist, use the album one.
        if t["ARTIST"].nil? 
          track[:track_artist_name] = obj[:album_artist_name]
        end
        
        track[:mood]              = _getOETElem(t["MOOD"])
        track[:tempo]             = _getOETElem(t["TEMPO"])

        # If track level GOET data exists, overwrite metadata from album.
        if not t["GENRE"].nil? 
          obj[:genre]         = _getOETElem(t["GENRE"])
        end
        if not t["ARTIST_ERA"].nil?
          obj[:artist_era]    = _getOETElem(t["ARTIST_ERA"])
        end
        if not t["ARTIST_TYPE"].nil?
          obj[:artist_type]   = _getOETElem(t["ARTIST_TYPE"])
        end
        if not t["ARTIST_ORIGIN"].nil?
          obj[:artist_origin] = _getOETElem(t["ARTIST_ORIGIN"])
        end
        obj[:tracks].push track
      end
      output.push obj
    end
    return output
  end

  # Function: merge_recursively
  # Merges two hash maps
  def merge_recursively(a, b)
    a.merge(b) {|key, a_item, b_item| merge_recursively(a_item, b_item) }
  end
  
  # Function: _getAttribElem
  # Gets key value pair from a url
  # Arguments:
  #   data
  #   attribute
  #   value
  def _getAttribElem(data, attribute, value)
    data.each do |g|
      attrib = Rack::Utils.parse_query URI(g).query
      if(attrib[attribute] == value) 
        return g
      end
    end
  end

  # Function: _getOETElem
  # Converts an Array to hashmap
  # Arguments:
  #   data
  def _getOETElem (data)
    output = Array.new()
    input = Array.new()
    if data.class.to_s != 'Array'
      input.push data
    else 
      input = data
    end
    input.each do |g|
      output.push({:id => g["ID"].to_i, :text => g})
    end
    return output
  end
end