## Gracenote ![Build Status](https://secure.travis-ci.org/rubygems/rubygems.org.png?branch=master)
A simple ruby wrapper gem for the Gracenote Music and TV API.

## Installation

Add this line to your application's Gemfile:

    gem 'gracenote'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gracenote



## Usage

You will need a Gracenote Client ID to use this module. Please visit https://developer.gracenote.com to get yours.

Each installed application also needs to have a User ID, which may be obtained by registering your Client ID with the Gracenote API. To do this, do:

	spec = {:clientID => "your_client_id", :clientTag => "your_client_tag"}
	api = Gracenote.new(spec)
	userID = api.registerUser

This registration should be done only once per application to avoid hitting your API quota (i.e. definitely do NOT do this before every query).

Once you have your userID, you can start making queries.

## Examples

	spec = {:clientID => "", :clientTag => "", :userID => ""}
	api = Gracenote.new(spec)
	
	api.findArtist('nevertheless')
	api.findTVShow('saved by the bell')
	api.fetchTVShow('238078046-4B86F4187EE2D215784CE4266CB83EA9')
	api.fetchSeason('238050049-B36CFD6F8B6FC76E2174F2A6E22515CD')
	api.findContributor('vince vaughn')
	api.fetchContributor('238498181-193BE2BA655E1490A3B8DF3ACCACEF3A')
