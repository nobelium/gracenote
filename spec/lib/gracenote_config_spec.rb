require "spec_helper"

describe Gracenote do 

  let(:gn) { Gracenote.new({:client_id => "7097600", :client_tag => "35312F0A797B9FE6F24AC32CDE64AC5B"}) }

  describe "Configuration" do

    it "should allow to read @client_id" do
      expect(gn.client_id).to eq("7097600")
    end

    it "should allow to read @client_tag" do
      expect(gn.client_tag).to eq("35312F0A797B9FE6F24AC32CDE64AC5B")
    end

    it "should allow to read api url" do
      expect(gn.api_endpoint_url).to eq("https://c" + gn.client_id + ".web.cddbp.net/webapi/xml/1.0/")
    end

    it "should allow to read userid" do
      expect(gn.user_id).to be_nil
    end

    context "allows to set @client_id" do
      let(:new_client_id) { "1234567" }
      before { gn.client_id = new_client_id }
      it { expect(gn.client_id).to eq(new_client_id) }
    end

    context "allows to set @client_tag" do
      let(:new_client_tag) { "1234567" }
      before { gn.client_tag = new_client_tag }
      it { expect(gn.client_tag).to eq(new_client_tag) }
    end

    context "allows to set api url" do
      let(:new_api_endpoint_url) { "http://asdf.com" }
      before { gn.api_endpoint_url = new_api_endpoint_url }
      it { expect(gn.api_endpoint_url).to eq(new_api_endpoint_url) }
    end
  end

end