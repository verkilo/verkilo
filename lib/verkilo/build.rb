module Verku
  class Build
    class Base
      def initialize(root_dir)
        @root_dir = root_dir
        @file = build_file
        # old = Yaml.load(File.read(path),:safe => true)
        puts books
        # @data = {
        #   :built_on => Date.today.to_s
        #   :build => old.build.to_i + 1
        # }
      end
    # def built_on
    #   return @data[:built_on]
    # end
    # def build
    #   return @data[:build]
    # end
    # private
    #   def save
    #     File.open(build_file,'w').write(@data.to_yaml)
    #   end
    #   def build_file
    #     path = @root_dir.join("_build.yml")
    #     raise "Invalid Verku directory; couldn't found #{path} file." unless File.file?(path)
    #     return path
    #   end
    end
  end
end
