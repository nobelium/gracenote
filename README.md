## Gracenote [![Build Status](https://travis-ci.org/nobelium/gracenote.png)](https://travis-ci.org/nobelium/gracenote) 
A simple ruby wrapper gem for the Gracenote Music API, which can retrieve Artist, Album and Track metadata with the most common options.

Inspired by <a href="https://github.com/cweichen/pygn">pygn project</a>.

Gracenote allows you to look up artists, albums, and tracks in the Gracenote database, and returns a number of metadata fields, including:

Basic metadata like Artist Name, Album Title, Track Title.
Descriptors like Genre, Origin, Mood, Tempo.
Related content like Album Art, Artist Image, Biographies.

Gracenote 1.2 supports TVShow queries 

## Installation

Add this line to your application's Gemfile:

    gem 'gracenote'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gracenote

## Rubygem
	
<a href="https://rubygems.org/gems/gracenote">https://rubygems.org/gems/gracenote</a>

## Usage

You will need a Gracenote Client ID to use this module. Please visit https://developer.gracenote.com to get yours.

Each installed application also needs to have a User ID, which may be obtained by registering your Client ID with the Gracenote API. To do this, do:

    spec = {:clientID => "your_client_id", :clientTag => "your_client_tag"}
    obj = Gracenote.new(spec)
    obj.registerUser

This registration should be done only once per application to avoid hitting your API quota (i.e. definitely do NOT do this before every query).

Once you have your Client ID and User ID, you can start making queries.

To search for the Kings of Convenience track "Homesick" from the album "Riot On An Empty Street",

    p obj.findTrack("Kings Of Convenience", "Riot On An Empty Street", "Homesick", '0').inspect

    p obj.findTVShow('saved by the bell').inspect

    p obj.fetchTVShow('238078046-4B86F4187EE2D215784CE4266CB83EA9').inspect

    p obj.fetchSeason('238050049-B36CFD6F8B6FC76E2174F2A6E22515CD').inspect

    p obj.findContributor('vince vaughn').inspect

    p obj.fetchContributor('238498181-193BE2BA655E1490A3B8DF3ACCACEF3A').inspect

    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
