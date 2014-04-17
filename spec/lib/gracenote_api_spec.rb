require "spec_helper"

describe Gracenote do 

  let(:gn) { Gracenote.new({:clientID => "7097600", :clientTag => "35312F0A797B9FE6F24AC32CDE64AC5B", :userID => "260455955426440098-6B2203CDDC1F35A06C7562D40EA538C0"}) }

  describe "track_api" do
    before do 
      VCR.insert_cassette 'track', :record => :new_episodes
    end

    after do 
      VCR.eject_cassette
    end

    it "records new track fixture" do
      gn.findTrack("Kings Of Convenience", "Riot On An Empty Street", "Homesick", '0')
    end
  end

  describe "tvshow_api" do
    before do 
      VCR.insert_cassette 'tvshow', :record => :new_episodes
    end

    after do 
      VCR.eject_cassette
    end

    it "records new tv show fixture" do
      gn.findTVShow('saved by the bell').inspect
    end
  end

end