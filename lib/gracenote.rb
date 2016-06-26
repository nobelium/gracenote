require "gracenote/HTTP"
require "crack"

class Gracenote

  # class variables
  @@ALL_RESULTS = '1'
  @@BEST_MATCH_ONLY = '0'

  attr_accessor :client_id, :client_tag, :user_id, :api_endpoint_url

  # Function: initialize
  # Sets the following instance variables
  #   @client_id
  #   @client_tag
  #   @user_id
  #   @api_endpoint_url
  def initialize (params)
    if params[:client_id].nil? || params[:client_id] == ""
      raise "@client_id cannot be nil"
    end
    if params[:client_tag].nil? || params[:client_tag] == ""
      raise "@client_tag cannot be nil"
    end

    @client_id = params[:client_id]
    @client_tag = params[:client_tag]
    @user_id = params[:user_id].nil? ? nil : params[:user_id]
    @api_endpoint_url = "https://c" + @client_id + ".web.cddbp.net/webapi/xml/1.0/"
  end

  # public methods
  public

  # Function: register_user
  # Registers a user and returns @user_id
  def register_user (client_id = nil)
    if client_id.nil?
      client_id = @client_id + "-" + @client_tag
    end

    unless @user_id.nil?
      puts "user already registered. No need to register again"
      return @user_id
    end

    #send req to server and get user ID
    data = "<QUERIES>
              <QUERY CMD='REGISTER'>
                <CLIENT>"+ client_id +"</CLIENT>
              </QUERY>
            </QUERIES>"
    resp = api(data)
    resp = check_res resp
    @user_id = resp['RESPONSES']['RESPONSE']['USER']
  end

  # Function: find_track
  # Finds a track
  # Arguments:
  #   artist_name
  #   album_title
  #   track_title
  #   match_mode
  def find_track(artist_name, album_title, track_title, match_mode = @@ALL_RESULTS)
    validate_register_user
    body = construct_album_query_body(artist_name, album_title, track_title, "", "ALBUM_SEARCH", match_mode)
    data = api(construct_query_req(body))
    parse_album_res(data)
  end

  # Function: find_artist
  # Finds a Artist
  # Arguments:
  #   artist_name
  #   match_mode
  def find_artist(artist_name, match_mode = @@ALL_RESULTS)
    find_track(artist_name, "", "", match_mode)
  end

  # Function: find_album
  # finds an Album
  # Arguments:
  #   artist_name
  #   album_title
  #   track_title
  #   match_mode
  def find_album(artist_name, album_title, match_mode = @@ALL_RESULTS)
    find_track(artist_name, album_title, "", match_mode)
  end

  # Function: album_toc
  # Fetches album metadata based on a table of contents.
  # Arguments:
  #   toc
  def album_toc(toc)
    # if @@user_id == nil
    #   register_user
    # end
    # body = "<TOC><OFFSETS>" + toc + "</OFFSETS></TOC>"
    # data = construct_album_query_body(body, "ALBUM_TOC")
    # parse_album_res(data)
  end

  # Function: fetch_oet_data
  # Gets data based on gn_id
  # Arguments:
  #   gn_id
  def fetch_oet_data(gn_id)
    validate_register_user

    body = "<GN_ID>" + gn_id + "</GN_ID>
              <OPTION>
                <PARAMETER>SELECT_EXTENDED</PARAMETER>
                  <VALUE>ARTIST_OET</VALUE>
              </OPTION>
              <OPTION>
                <PARAMETER>SELECT_DETAIL</PARAMETER>
                  <VALUE>ARTIST_ORIGIN:4LEVEL,ARTIST_ERA:2LEVEL,ARTIST_TYPE:2LEVEL</VALUE>
              </OPTION>"

    data = construct_query_req(body, "ALBUM_FETCH")
    resp = api(data)
    resp = check_res resp

    json = resp["RESPONSES"]

    output = Array.new()
    output[:artist_origin] = json["RESPONSE"]["ALBUM"]["ARTIST_ORIGIN"].nil? ? "" : get_oet_element(json["RESPONSE"]["ALBUM"]["ARTIST_ORIGIN"])
    output[:artist_era] = json["RESPONSE"]["ALBUM"]["ARTIST_ERA"].nil? ? "" : get_oet_element(json["RESPONSE"]["ALBUM"]["ARTIST_ERA"])
    output[:artist_type] = json["RESPONSE"]["ALBUM"]["ARTIST_TYPE"].nil? ? "" : get_oet_element(json["RESPONSE"]["ALBUM"]["ARTIST_TYPE"])
    output
  end

  # TVShow methods

  # Function: fetch_season
  # Fetches details of a season from gn_id
  # Arguments:
  #   gn_id
  def fetch_season (gn_id)
    validate_register_user

    body = "<GN_ID>" + gn_id + "</GN_ID>"
    data = construct_query_req(body, "SEASON_FETCH")

    resp = api(data)
    check_res(resp)
  end

  # Function: fetch_tv_show
  # Fetches details of TV Show from gn_id
  # Arguments:
  #   gn_id
  def fetch_tv_show (gn_id)


    validate_register_user

    body = "<GN_ID>" + gn_id + "</GN_ID>
              <OPTION>
                <PARAMETER>SELECT_EXTENDED</PARAMETER>
                <VALUE>IMAGE</VALUE>
              </OPTION>"

    data = construct_query_req(body, "SERIES_FETCH")
    resp = api(data)
    check_res(resp)
  end

  def validate_register_user
    register_user if @user_id.nil?
  end

  # Function: find_tv_show
  # Finds TVShows which matches the name
  # Arguments:
  #   name
  #   single
  def find_tv_show (name, single=true)
    validate_register_user

    single_text = single ? '<MODE>SINGLE_BEST</MODE>' : ''

    body = "<TEXT TYPE='TITLE'>" + name + "</TEXT>
            " + single_text + "
            <OPTION>
              <PARAMETER>SELECT_EXTENDED</PARAMETER>
              <VALUE>IMAGE</VALUE>
            </OPTION>"

    data = construct_query_req(body, "SERIES_SEARCH")

    resp = api(data)
    check_res(resp)
  end

  # Function: fetch_contributor
  # Fetches details of a contributor from gn_id
  # Arguments:
  #   gn_id
  def fetch_contributor (gn_id)
    validate_register_user

    body = "<GN_ID>" + gn_id + "</GN_ID>
            <OPTION>
              <PARAMETER>SELECT_EXTENDED</PARAMETER>
              <VALUE>IMAGE,MEDIAGRAPHY_IMAGES</VALUE>
            </OPTION>"

    data = construct_query_req(body, "CONTRIBUTOR_FETCH")
    resp = api(data)
    check_res(resp)
  end

  # Function: find_contributor
  # Find details of a contributor from name
  # Arguments:
  #   name
  def find_contributor (name)
    validate_register_user

    body = "<TEXT TYPE='NAME'>" + name + "</TEXT>
              <MODE>SINGLE_BEST</MODE>
            <OPTION>
              <PARAMETER>SELECT_EXTENDED</PARAMETER>
              <VALUE>IMAGE,MEDIAGRAPHY_IMAGES</VALUE>
            </OPTION>"

    data = construct_query_req(body, "CONTRIBUTOR_SEARCH")

    resp = api(data)
    check_res(resp)
  end

  ###################################################### protected methods ######################################################
  protected
  # Function: api
  # execute a query on gracenote webapi
  # Arguments:
  #   query
  def api (query)
    Gracenote::HTTP.post(@api_endpoint_url, query)
  end

  # Function: construct_query_req
  # Constructs Query
  # Arguments:
  #   body
  #   command
  def construct_query_req(body, command = "ALBUM_SEARCH")
    #construct the XML query
    "<QUERIES>
        <AUTH>
            <CLIENT>"+ @client_id + "-" + @client_tag + "</CLIENT>
            <USER>"+ @user_id + "</USER>
        </AUTH>
        <QUERY CMD=\"" + command + "\">
            " + body + "
        </QUERY>
    </QUERIES>"
  end

  # Function: construct_album_query_body
  # Constructs query body
  # Arguments:
  #   artist
  #   album
  #   track
  #   gn_id
  #   command
  #   match_mode
  def construct_album_query_body(artist, album, track, gn_id, command = "ALBUM_SEARCH", matchMode = @@ALL_RESULTS)
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

    body
  end

  # Function: check_res
  # Checks an XML response and converts it into json
  # Arguments:
  #   resp
  def check_res(resp)
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
    json
  end

  # Function: parse_album_res
  # Parse's an XML response
  # Arguments:
  #   resp
  def parse_album_res(resp)
    json = nil
    begin
      json = check_res resp
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

      obj[:album_gnid] = a["GN_ID"].to_i
      obj[:album_artist_name] = a["ARTIST"].to_s
      obj[:album_title] = a["TITLE"].to_s
      obj[:album_year] = a["DATE"].to_s
      obj[:genre] = get_oet_element(a["GENRE"])
      obj[:album_art_url] = get_attribute_element(a["URL"], "TYPE", "COVERART")

      # Artist metadata
      obj[:artist_image_url] = get_attribute_element(a["URL"], "TYPE", "ARTIST_IMAGE")
      obj[:artist_bio_url] = get_attribute_element(a["URL"], "TYPE", "ARTIST_BIOGRAPHY")
      obj[:review_url] = get_attribute_element(a["URL"], "TYPE", "REVIEW")

      # If we have artist OET info, use it.
      if not a["ARTIST_ORIGIN"].nil?
        obj[:artist_era] = get_oet_element(a["ARTIST_ERA"])
        obj[:artist_type] = get_oet_element(a["ARTIST_TYPE"])
        obj[:artist_origin] = get_oet_element(a["ARTIST_ORIGIN"])
      else
        # If not available, do a fetch to try and get it instead.
        obj = merge_recursively(obj, fetch_oet_data(a["GN_ID"]))
      end

      # Parse track metadata if there is any.
      obj[:tracks] = Array.new
      tracks = Array.new
      if a["TRACK"].class.to_s != 'Array'
        tracks.push a["TRACK"]
      else
        tracks = a["TRACK"]
      end
      tracks.each do |t|
        track = Hash.new

        track[:track_number] = t["TRACK_NUM"].to_s
        track[:track_gnid] = t["GN_ID"].to_s
        track[:track_title] = t["TITLE"].to_s
        track[:track_artist_name] = t["ARTIST"].to_s

        # If no specific track artist, use the album one.
        track[:track_artist_name] = obj[:album_artist_name] if t["ARTIST"].nil?

        track[:mood] = get_oet_element(t["MOOD"])
        track[:tempo] = get_oet_element(t["TEMPO"])

        # If track level GOET data exists, overwrite metadata from album.

        obj[:genre] = get_oet_element(t["GENRE"]) unless t["GENRE"].nil?
        obj[:artist_era] = get_oet_element(t["ARTIST_ERA"]) unless t["ARTIST_ERA"].nil?
        obj[:artist_type] = get_oet_element(t["ARTIST_TYPE"]) unless t["ARTIST_TYPE"].nil?
        obj[:artist_origin] = get_oet_element(t["ARTIST_ORIGIN"]) unless t["ARTIST_ORIGIN"].nil?
        obj[:tracks].push(track)
      end
      output.push(obj)
    end
    output
  end

  # Function: merge_recursively
  # Merges two hash maps
  def merge_recursively(a, b)
    a.merge(b) { |key, a_item, b_item| merge_recursively(a_item, b_item) }
  end

  # Function: get_attribute_element
  # Gets key value pair from a url
  # Arguments:
  #   data
  #   attribute
  #   value
  def get_attribute_element(data, attribute, value)
    data.each do |g|
      attrib = Rack::Utils.parse_query URI(g).query
      if attrib[attribute] == value
        return g
      end
    end
  end

  # Function: get_oet_element
  # Converts an Array to hashmap
  # Arguments:
  #   data
  def get_oet_element (data)
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
    output
  end
end