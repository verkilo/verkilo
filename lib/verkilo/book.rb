module Verkilo
  class Book
    def initialize(title, root_dir)
      @title = title
      @root_dir = root_dir
      @contents = ""
    end

    def contents
      @contents unless @contents.nil?
      @contents = files.map { |f| File.open(f,'r').read }.join("\n\n")
    end

    def to_s
      @title
    end
    alias title to_s

    def to_i
      self.contents.gsub(/[^a-zA-Z\s\d]/,"").split(/\W+/).count
    end
    alias wordcount to_i
    protected
      def files
        Dir["./#{@root_dir}/**/*.md"].sort
      end
  end
end
