require 'fileutils'
require 'yaml'
module Verkilo
  class Log
    def initialize(type, root_dir)
      @type = type
      @root_dir = root_dir
      @data = YAML.load(read_file)
      @today = Time.now.strftime("%F")
    end
    def data=(h)
      @data = @data.merge({@today => h})
    end
    def data
      @data
    end
    def write
      fname = self.filename + '.test'
      FileUtils.mkdir_p(File.dirname(fname))
      f = File.open(fname,'w')
      f.write(@data.to_yaml)
      f.close
    end
    def filename
      File.join([@root_dir, '.verkilo', "#{@type}.yml"])
    end
    private
      def read_file
        contents = "---"
        if File.exist?(self.filename)
          f = File.open(self.filename,'r')
          contents = f.read()
          f.close
        end
        return contents
      end
  end
end
