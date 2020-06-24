module Verkilo
  class Compile
    def initialize(root_dir)
      @root_dir = root_dir
      @build_dir = File.join(root_dir, 'build')
      FileUtils.mkdir_p(@build_dir)
      puts @build_dir
    end
  end
end
