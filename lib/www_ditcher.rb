class WwwDitcher

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.host.starts_with?("www.") and request.host.match(/.*/)
      [301, {"Location" => request.url.sub("//www.", "//")}, self]
    else
      @app.call(env)
    end

  end

  def each(&block)
  end

end
