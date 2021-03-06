require "verkilo/version"

module Verkilo
  class Error < StandardError; end
  ROOT = Pathname.new(File.dirname(__FILE__) + "/..")

  # require "verkilo/extensions/string"
  require "verkilo/cli"
  require "verkilo/book"
  require "verkilo/log"
  require "verkilo/shelf"
  require 'verkilo/version'

  Encoding.default_internal = "utf-8"
  Encoding.default_external = "utf-8"

  def self.config(root_dir = nil)
    root_dir ||= Pathname.new(Dir.pwd)
    path = root_dir.join("_verkilo.yml")

    raise "Invalid Verku directory; couldn't found #{path} file." unless File.file?(path)
    content = File.read(path)
    erb = ERB.new(content).result
    SafeYAML::OPTIONS[:default_mode] = true
    YAML.load(erb, :safe => true)
  end
  def self.logger
     @logger ||= Logger.new(File.open("/tmp/verkilo.log", "a"))
  end
end
