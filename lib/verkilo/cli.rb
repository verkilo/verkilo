require 'thor'
require 'verkilo/version'
module Verkilo
  class CLI < Thor
    desc "compile", "Convert Markdown files in book directory into PDF, EPUB, HTML & DOCX"
    long_desc <<-LONGDESC
  `verkilo compile` converts Markdown files in .book
  \x5 directories into PDF, ePUB, HTML & Word Doc.
  \x5 The compiled files will be put in the build
  \x5 directory in the root directory.

  See the Verkilo website (https://verkilo.com) for details

  > $ verkilo compile
LONGDESC
    map %w(-c --compile) => :compile
    def compile
      is_verkilo_project!
      shelf  = Verkilo::Shelf.new(root_dir)
      say "Compiling #{shelf}"
      shelf.books.each do |book|
        fork do
          book.compile
        end
      end
      Process.waitall
    end

    desc "merge", "Converts MS Word composite file back into Markdown files."
    map %w(-m --merge) => :merge
    def merge
      is_verkilo_project!
      say "Merging #{root_dir}"
    end

    desc "wordcount", "Wordcount the books in the repository and write to YAML file."
    map %w(-w --wordcount) => :wordcount
    method_option :offset
    long_desc <<-LONGDESC
  `verkilo wordcount` will count all the words
  \x5 in Markdown files in .book directories. The
  \x5 result will be added to a wordcount log YAML
  \x5 file inside the project's Verkilo configuration
  \x5 directory.

   You can optionally specify a second parameter,
  \x5 which will offset the date based on timezone.
  \x5 This is helpful when you are running this via
  \x5 a server or CI platform that uses a different
  \x5 timezone from your own.

  See the Verkilo website (https://verkilo.com) for details

  > $ verkilo wordcount --offset=-08:00
LONGDESC
    def wordcount
      is_verkilo_project!
      offset = options["offset"] || nil
      shelf  = Verkilo::Shelf.new(root_dir)
      wc_log = Verkilo::Log.new('wordcount',root_dir, offset)
      wc_log.data = shelf.wordcount
      wc_log.write

      say "Wordcount for #{shelf}: #{shelf.wordcount.to_yaml}Written to #{wc_log.filename}"
    end
    desc "version", "Prints the Verkilo's version information"
    map %w(-v --version) => :version
    def version
      say "Verkilo v#{Verkilo::VERSION}"
    end

    private
      def config_path
        root_dir.join(".verkilo")
      end
      def root_dir
        @root ||= Pathname.new(Dir.pwd)
      end
      def is_verkilo_project!
        say "Verkilo v#{Verkilo::VERSION}"
        unless File.exist?(config_path)
          say "You must run this command within a Verkilo directory."
          say "See the Verkilo website (https://verkilo.com) for details"
          exit 1
        end
      end
  end
end
