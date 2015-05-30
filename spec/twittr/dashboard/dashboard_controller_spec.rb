require 'spec_helper'


describe Twittr::DashboardController do

  def app
    Twittr::DashboardController
  end

  context "the feed" do
    xit "gets the page" do
      get "/", {}, {'rack.session' => { "screen_name" => "esanmiguelc" } }
      interactor_spy = spy('Interactor')
      allow(interactor_spy).to receive(:execute)
      allow(Twittr::AuthorizationInteractor).to receive(:new).and_return(interactor_spy)
      expect(last_response).to be_ok
    end

    xit "redirects if there is no session" do
      get "/"
      interactor_spy = spy('Interactor')
      allow(Twittr::AuthorizationInteractor).to receive(:new).and_return(interactor_spy)
      expect(last_response.location).to eq("http://example.org/")
    end

    it "calls the interactor" do
      interactor_spy = spy('Interactor')
      allow(interactor_spy).to receive(:execute)
      allow(Twittr::AuthorizationInteractor).to receive(:new).and_return(interactor_spy)
      get "/"
      expect(Twittr::AuthorizationInteractor).to have_received(:new).with(session: session)
    end
  end

  context "sending the status update to the api" do
    let(:interactor_spy) { spy("Interactor") }
    let(:params) {{  "status" => "Hello World" }}

    it "has a valid route" do
      allow(interactor_spy).to receive(:execute)
      allow(Twittr::UpdateStatusInteractor).to receive(:new).and_return(interactor_spy)
      post "/update_status", params
      expect(last_response).to be_ok
    end

    it "calls the interactor" do
      allow(interactor_spy).to receive(:execute)
      allow(Twittr::UpdateStatusInteractor).to receive(:new).and_return(interactor_spy)
      post "/update_status", params
      expect(Twittr::UpdateStatusInteractor).to have_received(:new).with(params: params, session: session)
    end

    it "calls execute" do
      allow(Twittr::UpdateStatusInteractor).to receive(:new).and_return(interactor_spy)
      post "/update_status", params
      expect(Twittr::UpdateStatusInteractor).to have_received(:new).with(params: params, session: session)    
      expect(interactor_spy).to have_received(:execute)
    end
  end

  context "calls the twitter api for the user information" do
    it "calls the interactor" do
      interactor_spy = spy("Interactor")
      allow(interactor_spy).to receive(:execute)
      allow(Twittr::GetUserInteractor).to receive(:new).and_return(interactor_spy)
      get "/twitter_user"
      expect(Twittr::GetUserInteractor).to have_received(:new).with({session: session})
    end

    it "calls execute" do
      interactor_spy = spy("Interactor")
      allow(Twittr::GetUserInteractor).to receive(:new).and_return(interactor_spy)
      get "/twitter_user"
      expect(Twittr::GetUserInteractor).to have_received(:new).with({session: session})    
      expect(interactor_spy).to have_received(:execute)
    end
  end

  context "calls the api for the feed" do
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

  def session
    last_request.env['rack.session']
  end
end
