require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /" do
    it "returns an html hello message with the given names" do
      response = get("/", name: "Mergz")

      expect(response.body).to include ("<h1>Hello Mergz!</h1>")
    end

    it "returns an html hello message with a different name" do
      response = get("/", name: "Mergim")

      expect(response.body).to include ("<h1>Hello Mergim!</h1>")

      # <img src="hello.jpg" />
      # expect(response.body).to include('<img src="hello.jpg" />')
    end
  end

  def reset_artists_table
    seed_sql = File.read("spec/seeds/artists_seeds.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test_1" })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_artists_table
  end

  context "GET /albums" do
    it "should return the list of albums" do
      response = get("/albums")

      expected_response = "Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /albums" do
    it "should create a new album" do
      response = post("/albums", title: "OK Computer", release_year: "1997", artist_id: "1")

      expect(response.status).to eq(200)
      expect(response.body).to eq ("")

      response = get("/albums")

      expect(response.body).to include("OK Computer")
    end
  end

  context "GET /artists" do
    it "should return the list of artists" do
      response = get("/artists")

      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /artists" do
    it "should create a new artist" do
      response = post("/artists", name: "Wild nothing", genre: "Indie")

      expect(response.status).to eq(200)
      expect(response.body).to eq ("")

      response = get("/artists")

      expect(response.body).to include("Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing")
    end
  end
end
