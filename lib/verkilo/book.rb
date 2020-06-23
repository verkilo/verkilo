module Verkilo
  class Book
    def initialize(title, root_dir)
      @title = title
      @root_dir = root_dir
      @contents = ""
    end
    def title
      @title
    end
    def contents
      @contents unless @contents.nil?
      @contents = files.map { |f| File.open(f,'r').read }.join("\n\n")
    end
    def wordcount
      self.contents.gsub(/[^a-zA-Z\s\d]/,"").split(/\W+/).count
    end
    protected
      def files
        Dir["./#{@root_dir}/**/*.md"].sort
      end
  end
end
