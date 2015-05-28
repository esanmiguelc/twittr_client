require 'spec_helper'

describe "Parsing the API response" do
  it "splits an empty response" do
    expect(Twittr::ResponseParser.new("").parse).to eq({})
  end

  it "splits a response with one parameter" do
    data = { "one" => "two" }
    expect(Twittr::ResponseParser.new("one=two").parse).to eq(data)
  end

  it "splits a response with two parameters" do
    data = { "one" => "two", "three" => "four" }
    expect(Twittr::ResponseParser.new("one=two&three=four").parse).to eq(data)
  end

  it "gets a parameter" do
    parser = Twittr::ResponseParser.new("one=two&three=four")
    parser.parse
    expect(parser.get_param("one")).to eq("two")
  end
end
