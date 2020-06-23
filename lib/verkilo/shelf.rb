module Verkilo
  class Shelf
    def initialize(root_dir)
      @root_dir = root_dir
      @books = []
    end
    def books
      return @books unless @books.empty?
      @books = Dir["#{@root_dir}/**/.book"].map do |book_flag|
        dir = File.dirname(book_flag)
        title = File.basename(dir)
        Book.new(title, dir)
      end
    end
  end
end
