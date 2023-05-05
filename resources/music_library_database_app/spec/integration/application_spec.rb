require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_artists_table
    seed_sql = File.read("spec/seeds/music_library.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test_1" })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_artists_table
  end

  context "GET /" do
    it "returns an hello page if the password is correct" do
      response = get("/", password: "abcd")

      expect(response.body).to include("Hello!")
    end

    it "returns a forbidden if the password is incorrect" do
      response = get("/", password: "skhdhdkskhd")

      expect(response.body).to include("Access forbidden!")
    end
  end

  context "GET /albums/:id" do
    it " should return info about album 2" do
      response = get("/albums/2")

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Surfer Rosa</h1>")
      expect(response.body).to include("Release year: 1988")
      expect(response.body).to include("Artist: Pixies")
    end
  end

  context "GET /albums" do
    it "should return the list of albums with information" do
      response = get("/albums")

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="albums/1">Doolittle</a>')
      expect(response.body).to include('<a href="albums/2">Surfer Rosa</a>')
      expect(response.body).to include('<a href="albums/3">Waterloo</a>')
      expect(response.body).to include('<a href="albums/6">Lover</a>')
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

  context "GET /artists/:id" do
    it " should return info about artist 1" do
      response = get("/artists/1")

      expect(response.status).to eq(200)
      expect(response.body).to include("Name: Pixies")
      expect(response.body).to include("Genre: Rock")
    end
  end

  context "GET /artists" do
    it "should return the list of artists" do
      response = get("/artists")

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="artists/2">ABBA</a>')
    end
  end

  context "POST /artists" do
    it "should create a new artist" do
      response = post("/artists", name: "Wild nothing", genre: "Indie")

      expect(response.status).to eq(200)
      expect(response.body).to eq ("")

      response = get("/artists")

      expect(response.body).to include("Wild nothing")
    end
  end

  context "POST /albums/new" do
    it "adds a new album to the database" do
      response = post("/albums/new", title: "born to run", release_year: "1976", artist_id: "2")

      expect(response.status).to eq(200)
      expect(response.body).to include("<p>You successfully added: born to run</p>")
    end

    it "adds a new album to the database" do
      response = post("/albums/new", title: "born in the USA", release_year: "1986", artist_id: "2")

      expect(response.status).to eq(200)
      expect(response.body).to include("<p>You successfully added: born in the USA</p>")
    end
  end

  context "POST /artist/new" do
    it "adds a new artist to the database" do
      response = post("/artist/new", name: "Bruce Springsteen", genre: "Rock")

      expect(response.status).to eq(200)
      expect(response.body).to include("<p>You successfully added: Bruce Springsteen</p>")
    end

    it "adds a new artist to the database" do
      response = post("/artist/new", name: "Beyonce", genre: "Pop")

      expect(response.status).to eq(200)
      expect(response.body).to include("<p>You successfully added: Beyonce</p>")
    end
  end
end
