module Verkilo
  class Wordcount
    def self.run(root_dir, options)
      wc = new(root_dir, options)
      puts "HERE #{root_dir}"
      puts SourceList.new(root_dir).books.map.inspect
      # exporter.export
    end
    def initialize(root_dir, options)
      @root_dir = root_dir
      @options = options
    end
  end
end
