require "spec_helper"

describe Gracenote do 

  let(:gn) { Gracenote.new({:client_id => "7097600", :client_tag => "35312F0A797B9FE6F24AC32CDE64AC5B"}) }

  describe "Configuration" do
    it "should allow to read @client_id" do
      id = gn.client_id
      id.should == "7097600"
    end

    it "should allow to read @client_tag" do
      tag = gn.client_tag
      tag.should == "35312F0A797B9FE6F24AC32CDE64AC5B"
    end

    it "should allow to read api url" do
      url = gn.api_endpoint_url
      url.should == "https://c" + gn.client_id + ".web.cddbp.net/webapi/xml/1.0/"
    end

    it "should allow to read userid" do
      userid = gn.user_id
      userid.should == nil
    end

    it "allows to set @client_id" do
      client_id = gn.client_id
      gn.client_id = "1234567"
      gn.client_id.should == "1234567"
      gn.client_id = client_id
    end

    it "allows to set @client_tag" do
      client_tag = gn.client_tag
      gn.client_tag = "1234567"
      gn.client_tag.should == "1234567"
      gn.client_tag = client_tag
    end

    it "allows to set api url" do 
      api_url = gn.api_endpoint_url
      gn.api_endpoint_url = "http://asdf.com"
      gn.api_endpoint_url.should == "http://asdf.com"
      gn.api_endpoint_url = api_url
    end
  end

end