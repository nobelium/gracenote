# Gracenote

A simple ruby wrapper gem for the Gracenote Music API, which can retrieve Artist, Album and Track metadata with the most common options.

Inspired from <a href="https://github.com/cweichen/pygn">pygn project</a>.

Gracenote allows you to look up artists, albums, and tracks in the Gracenote database, and returns a number of metadata fields, including:

Basic metadata like Artist Name, Album Title, Track Title.
Descriptors like Genre, Origin, Mood, Tempo.
Related content like Album Art, Artist Image, Biographies.

## Installation

Add this line to your application's Gemfile:

    gem 'gracenote'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gracenote

## Rubygem
	
	[https://rubygems.org/gems/gracenote](https://rubygems.org/gems/gracenote)

## Usage

You will need a Gracenote Client ID to use this module. Please visit https://developer.gracenote.com to get yours.

Each installed application also needs to have a User ID, which may be obtained by registering your Client ID with the Gracenote API. To do this, do:

    spec = {:clientID => "your_client_id", :clientTag => "your_client_tag"}
    obj = Gracenote.new(spec)
    obj.registerUser

This registration should be done only once per application to avoid hitting your API quota (i.e. definitely do NOT do this before every query).

Once you have your Client ID and User ID, you can start making queries.

To search for the Kings of Convenience track "Homesick" from the album "Riot On An Empty Street",

    result = obj.findTrack("Kings Of Convenience", "Riot On An Empty Street", "Homesick", '0').inspect
    p result

    "[{
    	:album_gnid=>59247312, 
    	:album_artist_name=>\"Kings Of Convenience\", 
    	:album_title=>\"Riot On An Empty Street\", 
    	:album_year=>\"2004\", 
    	:genre=>[
    				{:id=>0, :text=>\"Alternative & Punk\"}, 
    				{:id=>0, :text=>\"Indie Rock\"}, 
    				{:id=>0, :text=>\"Indie Pop\"}
    			], 
		:album_art_url=>[
							\"https://web.content.cddbp.net/cgi-bin/content-thin?id=8D43DA988315CC43&client=7097600&class=cover&origin=front&size=medium&type=image/jpeg&tag=02BRjsNLZYowVXp0wIWfvtWO1QSISZ1t0YD7Pd5n-khavy0PkPDB6XOg\", 
							\"https://web.content.cddbp.net/cgi-bin/content-thin?id=22DA84B96832BF4F&client=7097600&class=biography&type=text/plain&tag=021ZJF4GBUyZMsNd2KuX0cXK8Av.xR0QtaXUGYjxzx483r2cTnn668Bg\", 
							\"https://web.content.cddbp.net/cgi-bin/content-thin?id=797304D567E8970F&client=7097600&class=image&size=medium&type=image/jpeg&tag=02FtBZ1phn1i5tao2YrRWSM27dc65Xtbdz5uqCVFlbTj-szaKJwxQU6Q\", 
							\"https://web.content.cddbp.net/cgi-bin/content-thin?id=4045DA976DB1DEFA&client=7097600&class=review&type=text/plain&tag=02iuit24FNZPZYA-sNZLRWwy7XdmU89p7UpAeXP29wiMJ-dYVuuw2i1w\"
						], 
		:artist_image_url=>[
								\"https://web.content.cddbp.net/cgi-bin/content-thin?id=8D43DA988315CC43&client=7097600&class=cover&origin=front&size=medium&type=image/jpeg&tag=02BRjsNLZYowVXp0wIWfvtWO1QSISZ1t0YD7Pd5n-khavy0PkPDB6XOg\", 
								\"https://web.content.cddbp.net/cgi-bin/content-thin?id=22DA84B96832BF4F&client=7097600&class=biography&type=text/plain&tag=021ZJF4GBUyZMsNd2KuX0cXK8Av.xR0QtaXUGYjxzx483r2cTnn668Bg\", 
								\"https://web.content.cddbp.net/cgi-bin/content-thin?id=797304D567E8970F&client=7097600&class=image&size=medium&type=image/jpeg&tag=02FtBZ1phn1i5tao2YrRWSM27dc65Xtbdz5uqCVFlbTj-szaKJwxQU6Q\", 
								\"https://web.content.cddbp.net/cgi-bin/content-thin?id=4045DA976DB1DEFA&client=7097600&class=review&type=text/plain&tag=02iuit24FNZPZYA-sNZLRWwy7XdmU89p7UpAeXP29wiMJ-dYVuuw2i1w\"
							], 
		:artist_bio_url=>[
							\"https://web.content.cddbp.net/cgi-bin/content-thin?id=8D43DA988315CC43&client=7097600&class=cover&origin=front&size=medium&type=image/jpeg&tag=02BRjsNLZYowVXp0wIWfvtWO1QSISZ1t0YD7Pd5n-khavy0PkPDB6XOg\", 
							\"https://web.content.cddbp.net/cgi-bin/content-thin?id=22DA84B96832BF4F&client=7097600&class=biography&type=text/plain&tag=021ZJF4GBUyZMsNd2KuX0cXK8Av.xR0QtaXUGYjxzx483r2cTnn668Bg\", 
							\"https://web.content.cddbp.net/cgi-bin/content-thin?id=797304D567E8970F&client=7097600&class=image&size=medium&type=image/jpeg&tag=02FtBZ1phn1i5tao2YrRWSM27dc65Xtbdz5uqCVFlbTj-szaKJwxQU6Q\", 
							\"https://web.content.cddbp.net/cgi-bin/content-thin?id=4045DA976DB1DEFA&client=7097600&class=review&type=text/plain&tag=02iuit24FNZPZYA-sNZLRWwy7XdmU89p7UpAeXP29wiMJ-dYVuuw2i1w\"
						], 
		:review_url=>[
						\"https://web.content.cddbp.net/cgi-bin/content-thin?id=8D43DA988315CC43&client=7097600&class=cover&origin=front&size=medium&type=image/jpeg&tag=02BRjsNLZYowVXp0wIWfvtWO1QSISZ1t0YD7Pd5n-khavy0PkPDB6XOg\", 
						\"https://web.content.cddbp.net/cgi-bin/content-thin?id=22DA84B96832BF4F&client=7097600&class=biography&type=text/plain&tag=021ZJF4GBUyZMsNd2KuX0cXK8Av.xR0QtaXUGYjxzx483r2cTnn668Bg\", 
						\"https://web.content.cddbp.net/cgi-bin/content-thin?id=797304D567E8970F&client=7097600&class=image&size=medium&type=image/jpeg&tag=02FtBZ1phn1i5tao2YrRWSM27dc65Xtbdz5uqCVFlbTj-szaKJwxQU6Q\", 
						\"https://web.content.cddbp.net/cgi-bin/content-thin?id=4045DA976DB1DEFA&client=7097600&class=review&type=text/plain&tag=02iuit24FNZPZYA-sNZLRWwy7XdmU89p7UpAeXP29wiMJ-dYVuuw2i1w\"
					], 
		:artist_era=>[{:id=>0, :text=>\"2000's\"}], 
		:artist_type=>[{:id=>0, :text=>\"Male\"}, {:id=>0, :text=>\"Male Duo\"}], 
		:artist_origin=>[{:id=>0, :text=>\"Scandinavia\"}, {:id=>0, :text=>\"Norway\"}], 
		:tracks=>[{
					:track_number=>\"1\", 
					:track_gnid=>\"59247313-E198021B46C38679362C35619E93396B\", 
					:track_title=>\"Homesick\", 
					:track_artist_name=>\"Kings Of Convenience\", 
					:mood=>[{:id=>0, :text=>\"Melancholy\"}, {:id=>0, :text=>\"Light Melancholy\"}], 
					:tempo=>[{:id=>0, :text=>\"Medium Tempo\"}, {:id=>0, :text=>\"Medium Slow\"}, {:id=>0, :text=>\"60s\"}]
					}]
	}]"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
