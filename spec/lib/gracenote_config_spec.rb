require "spec_helper"

describe Gracenote do 

  let(:gn) { Gracenote.new({:clientID => "7097600", :clientTag => "35312F0A797B9FE6F24AC32CDE64AC5B"}) }

  describe "Configuration" do
    it "should allow to read clientID" do
      id = gn.clientID
      id.should == "7097600"
    end

    it "should allow to read clientTag" do
      tag = gn.clientTag
      tag.should == "35312F0A797B9FE6F24AC32CDE64AC5B"
    end

    it "should allow to read api url" do
      url = gn.apiURL
      url.should == "https://c" + gn.clientID + ".web.cddbp.net/webapi/xml/1.0/"
    end

    it "should allow to read userid" do
      userid = gn.userID
      userid.should == nil
    end

    it "allows to set clientID" do
      clientID = gn.clientID
      gn.clientID = "1234567"
      gn.clientID.should == "1234567"
      gn.clientID = clientID
    end

    it "allows to set clientTag" do
      clientTag = gn.clientTag
      gn.clientTag = "1234567"
      gn.clientTag.should == "1234567"
      gn.clientTag = clientTag
    end

    it "allows to set api url" do 
      apiurl = gn.apiURL
      gn.apiURL = "http://asdf.com"
      gn.apiURL.should == "http://asdf.com"
      gn.apiURL = apiurl
    end
  end

end