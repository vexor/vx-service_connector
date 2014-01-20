require 'json'

module ReadFixtureSpecSupport
  def read_fixture(name)
    File.read File.expand_path("../../fixtures/#{name}", __FILE__)
  end

  def read_json_fixture(name)
    JSON.parse read_fixture(name + ".json")
  end
end

