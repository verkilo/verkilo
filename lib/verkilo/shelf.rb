module Verkilo
  class Shelf
    def initialize(root_dir)
      @root_dir = root_dir
      @books = []
      @wordcount = Hash.new
    end
    def to_s
      File.basename(@root_dir)
    end
    alias title to_s

    def to_i
      self.books.each do |b|
        @wordcount[b.title] = b.to_i
      end
      return @wordcount
    end
    alias wordcount to_i
    
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
