require "spec_helper"

describe Gracenote do 

  let(:gn) { Gracenote.new({:clientID => "7097600", :clientTag => "35312F0A797B9FE6F24AC32CDE64AC5B", :userID => "259611531832193638-19110695509BAD8C550883C21A289003"}) }

  describe "track_api" do
    before do 
      VCR.insert_cassette 'track_find', :record => :new_episodes
    end

    after do 
      VCR.eject_cassette
    end
  
    it "must have a findTrack method" do
      gn.should respond_to :findTrack
    end

    it "records new track fixture" do
      gn.findTrack("Kings Of Convenience", "Riot On An Empty Street", "Homesick", '0')
    end

    it "returns result for findTrack query" do
      gn.findTrack("Kings Of Convenience", "Riot On An Empty Street", "Homesick", '0').should_not == nil
    end
  end

  describe "findTVShow" do
    before do 
      VCR.insert_cassette 'tvshow_find', :record => :new_episodes
    end

    after do 
      VCR.eject_cassette
    end
    
    it "must have a findTVShow method" do
      gn.should respond_to :findTVShow
    end
    
    it "records new tv show fixture" do
      gn.findTVShow('saved by the bell').inspect
    end

    it "returns result for findTVShow query" do
      gn.findTVShow('saved by the bell').inspect.should_not == nil
    end
  end

  describe "fetchTVShow" do 
    before do 
      VCR.insert_cassette 'tvshow_fetch', :record => :new_episodes
    end

    after do 
      VCR.eject_cassette
    end

    it "must have a fetchTVShow method" do
      gn.should respond_to :fetchTVShow
    end

    it "records fetching a tv show" do 
      gn.fetchTVShow('238078046-4B86F4187EE2D215784CE4266CB83EA9')
    end

    it "returns result for fetchTVShow query" do 
      gn.fetchTVShow('238078046-4B86F4187EE2D215784CE4266CB83EA9').should_not == nil
    end
  end

  describe "fetchSeason" do 
    before do 
      VCR.insert_cassette 'tvshow_fetch_season', :record => :new_episodes
    end

    after do 
      VCR.eject_cassette
    end    

    it "must have a fetchSeason method" do
      gn.should respond_to :fetchSeason
    end

    it "records fetching a season" do
      gn.fetchSeason('238050049-B36CFD6F8B6FC76E2174F2A6E22515CD')
    end

    it "returns result for fetchSeason query" do
      gn.fetchSeason('238050049-B36CFD6F8B6FC76E2174F2A6E22515CD').should_not == nil
    end
  end

  describe "findContributor" do 
    before do 
      VCR.insert_cassette 'tvshow_find_contributor', :record => :new_episodes
    end

    after do 
      VCR.eject_cassette
    end    

    it "must have a findContributor method" do
      gn.should respond_to :findContributor
    end

    it "records finding a contributor" do 
      gn.findContributor('vince vaughn')
    end

    it "returns result for findContributor query" do 
      gn.findContributor('vince vaughn').should_not == nil
    end
  end

  describe "fetchContributor" do 
    before do 
      VCR.insert_cassette 'tvshow_fetch_contributor', :record => :new_episodes
    end

    after do 
      VCR.eject_cassette
    end    

    it "must have a fetchContributor method" do
      gn.should respond_to :fetchContributor
    end

    it "records finding a contributor using gn_id" do
      gn.fetchContributor('238498181-193BE2BA655E1490A3B8DF3ACCACEF3A')
    end

    it "returns result for fetchContributor query" do
      gn.fetchContributor('238498181-193BE2BA655E1490A3B8DF3ACCACEF3A').should_not == nil
    end
  end
end