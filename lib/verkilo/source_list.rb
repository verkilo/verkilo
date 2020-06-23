module Verkilo
  class SourceList
    def initialize(root_dir)
      @root_dir = root_dir
    end
    # Get Books
    # Get files within book
    def books
      @books ||= Dir["#{@root_dir}/**/.book"].map
    end
  end
end
