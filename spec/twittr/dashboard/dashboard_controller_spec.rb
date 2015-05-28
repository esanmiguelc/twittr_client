require 'spec_helper'


describe Twittr::DashboardController do

  def app
    Twittr::DashboardController
  end

  context "the feed" do
    it "gets the feed" do
      get "/", {}, {'rack.session' => { "screen_name" => "esanmiguelc" } }

      expect(last_response).to be_ok
    end

    it "redirects if there is no session" do
      get "/"

      expect(last_response.location).to eq("http://example.org/")
    end
  end

  context "calls the api" do
    let (:params) { 
      {
        end_point: "https://api.twitter.com/1.1/statuses/home_timeline.json",
        http_method: "GET",
        secret: "123",
        token: "456"
      }
    }

    it "Builds the signature correctly" do
      params = {
        end_point: "https://api.twitter.com/1.1/statuses/home_timeline.json",
        http_method: "GET",
        secret: "123",
        token: "456"
      }

      mock_signature = double("MockSignature")
      mock_requester = double("MockRequester", :make_call => "123")
      allow(Twittr::OAuthSignature).to receive(:new).with(params).and_return(mock_signature)
      allow(Twittr::Requester).to receive(:new).with(mock_signature).and_return(mock_requester)
      get "/home_timeline", {}, {'rack.session' => { "screen_name" => "esanmiguelc",
                                        "token" => "456",
                                        "secret" => "123"} }

      expect(Twittr::OAuthSignature).to have_received(:new).with(params)
    end

    it "sets up the requester" do
      params = {
        end_point: "https://api.twitter.com/1.1/statuses/home_timeline.json",
        http_method: "GET",
        secret: "123",
        token: "456"
      }

      mock_requester = double("MockRequester", :make_call => "123")
      mock_signature = double("MockSignature")
      allow(Twittr::OAuthSignature).to receive(:new).with(params).and_return(mock_signature)
      expect(Twittr::Requester).to receive(:new).with(mock_signature).and_return(mock_requester)

      get "/home_timeline", {}, {'rack.session' => { "screen_name" => "esanmiguelc",
                                        "token" => "456",
                                        "secret" => "123"} }
    end

    it "makes the api call" do
      params = {
        end_point: "https://api.twitter.com/1.1/statuses/home_timeline.json",
        http_method: "GET",
        secret: "123",
        token: "456"
      }
      mock_requester = double("MockRequester", :make_call => "123")
      allow(Twittr::OAuthSignature).to receive(:new).with(params).and_return("signature")
      expect(Twittr::Requester).to receive(:new).with("signature").and_return(mock_requester)

      get "/home_timeline", {}, {'rack.session' => { "screen_name" => "esanmiguelc",
                                        "token" => "456",
                                        "secret" => "123"} }

      expect(mock_requester).to have_received(:make_call)
    end
  end
end
