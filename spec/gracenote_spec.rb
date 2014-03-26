require "spec_helper"

describe Gracenote do 

  before :all do
    @obj = Gracenote.new({:clientID => "7097600", :clientTag => "35312F0A797B9FE6F24AC32CDE64AC5B"})
  end

  describe "Configuration" do
    it "should allow to read clientID" do
      id = @obj.clientID
      id.should == "7097600"
    end

    it "should allow to read clientTag" do
      tag = @obj.clientTag
      tag.should == "35312F0A797B9FE6F24AC32CDE64AC5B"
    end

    it "should allow to read api url" do
      url = @obj.apiURL
      url.should == "https://c" + @obj.clientID + ".web.cddbp.net/webapi/xml/1.0/"
    end

    it "should allow to read userid" do
      userid = @obj.userID
      userid.should == nil
    end

    it "allows to set clientID" do
      clientID = @obj.clientID
      @obj.clientID = "1234567"
      @obj.clientID.should == "1234567"
      @obj.clientID = clientID
    end

    it "allows to set clientTag" do
      clientTag = @obj.clientTag
      @obj.clientTag = "1234567"
      @obj.clientTag.should == "1234567"
      @obj.clientTag = clientTag
    end

    it "allows to set api url" do 
      apiurl = @obj.apiURL
      @obj.apiURL = "http://asdf.com"
      @obj.apiURL.should == "http://asdf.com"
      @obj.apiURL = apiurl
    end

  end

end