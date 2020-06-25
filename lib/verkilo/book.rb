module Verkilo
  class Book
    def initialize(title, root_dir, repo="none")
      @title = title
      @root_dir = root_dir
      @resource_dir = File.join(File.dirname(File.expand_path(__FILE__)), '../../resources')
      @contents = ""
      @today = Time.now.strftime("%F")
      @repo = repo
      @bib = Dir["#{@root_dir}/**/*.bib"].first || nil
      @csl = Dir["#{@root_dir}/**/*.csl"].first || nil
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

    def compile(dir=".")
      @build_dir = File.join(dir, 'build', @title)
      FileUtils.mkdir_p(@build_dir)
      src = File.join("/tmp", "#{@title}.md")
      f = File.new(src,'w')
      f.write(self.contents)
      f.close
      %w(frontmatter).each {|action|
        dst = File.join(["/tmp", "#{@title}-#{action}.tex"])
        pandoc(action, src, dst)
      }
      %w(yaml tex pdf docx html epub docbook).each do |action|
        pandoc(action,src)
      end
    end

    protected
      def files
        Dir["./#{@root_dir}/**/*.md"].sort
      end
      def epub_image
        fname = File.join(['.', 'covers', "#{@title}-epub.png"])
        raise "Epub Cover Missing (#{fname})" unless File.exist?(fname)
        return fname
      end
      def flags(action=nil)
        templates_dir = @resource_dir
        css_file = if File.exist?(".verkilo/style.css")
          ".verkilo/style.css"
        else
          File.join([templates_dir, "style.css"])
        end

        f = %Q(
          --lua-filter #{File.join([templates_dir, "latex.lua"])} \
          --metadata-file=.verkilo/defaults.yml \
          --fail-if-warnings
        ) + case action
          when 'docx'
            %Q(
              --reference-doc=#{File.join([templates_dir, "reference.docx"])}
            )
          when 'epub'
            %Q(
              --css=#{css_file} \
              --epub-cover-image=#{epub_image} \
              --template=#{File.join([templates_dir, "epub.html"])} \
              --webtex
            )
          when 'html'
            %Q(
              --css=#{css_file} \
              --self-contained \
              --standalone --to=html5 \
              --template=#{File.join([templates_dir, "epub.html"])} \
              --html-q-tags
              --webtex
            )
          when 'tex', 'pdf'
            %Q(
              -B #{File.join(['/tmp',"#{@title}-frontmatter.tex"])} \
              --pdf-engine=xelatex \
              --template=#{File.join([templates_dir, "template.tex"])} \
              -V documentclass=memoir \
              -V has-frontmatter=true \
              -V indent=true \
              --webtex
            )
          when 'docbook'
            %Q(-t docbook)
          when 'yaml'
            %Q(
              -t markdown \
              --template=#{File.join([templates_dir, "yaml.md"])}
            )
          when 'frontmatter'
            %Q(
              --pdf-engine=xelatex
              --template=#{File.join([templates_dir, "#{action}.tex"])}
            )
          else
            ""
        end
        f.gsub(/\s+/," ").strip
      end
      def pandoc(action,src,fname=nil)
        fname = File.join(@build_dir, "#{@title}-#{@today}.#{action}") if fname.nil?
        bib = (@bib.nil?) ? "" : " --bibliography #{bib}"
        csl = (@csl.nil?) ? "" : " --csl #{csl}"

        cmd = "pandoc -o #{fname} #{flags(action)} #{src}"
        puts "%#{10}s .. %-11s => %s %s" % [@title, action, fname, `#{cmd}`]
      end
  end
end
