require (File.expand_path('./../../../spec_helper', __FILE__))

describe "HTTP" do
  it "must have a get method" do
    Gracenote::HTTP.should respond_to :get
  end

  it "must have a post method" do
    Gracenote::HTTP.should respond_to :post
  end
end
