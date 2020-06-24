require 'thor'
require 'verkilo/version'
module Verkilo
  class CLI < Thor
    desc "compile", "Convert Markdown files in book directory into PDF, EPUB, HTML & DOCX"
    map %w(-c --compile) => :compile
    def compile(root_dir=".")
      shelf  = Verkilo::Shelf.new(root_dir)
      puts "Compiling #{shelf}"
      c = Verkilo::Compile.new(root_dir)
    end
    desc "proof", "Convert Markdown files in book directory into PDF, EPUB, HTML & DOCX"
    map %w(-p --proof) => :proof
    def proof(root_dir=".")
      puts "Proofing #{root_dir}"
    end

    desc "merge", "Converts MS Word composite file back into Markdown files."
    map %w(-m --merge) => :merge
    def merge(root_dir=".")
      puts "Merging #{root_dir}"
    end

    desc "wordcount", "Wordcount the books in the repository and write to YAML file."
    map %w(-w --wordcount) => :wordcount
    def wordcount(root_dir=".")
      shelf  = Verkilo::Shelf.new(root_dir)
      wc_log = Verkilo::Log.new('wordcount',root_dir)
      wc_log.data = shelf.wordcount
      wc_log.write

      puts "Wordcount for #{shelf}: #{shelf.wordcount.to_yaml}Written to #{wc_log.filename}"
    end
    desc "version", "Prints the Verkilo's version information"
    map %w(-v --version) => :version
    def version
      say "Verkilo version #{Verkilo::VERSION}"
    end

    private
      # def config
      #   YAML.load_file(config_path).with_indifferent_access
      # end
      def config_path
        root_dir.join(".verkilo/defaults.yml")
      end
      def root_dir
        @root ||= Pathname.new(Dir.pwd)
      end
      def inside_ebook!
        unless File.exist?(config_path)
          raise Error, "You have to run this command from inside a Verkilo directory."
        end
      end
  end
end
