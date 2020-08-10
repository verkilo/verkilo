# require 'fileutils'
require 'yaml'
module Verkilo
  class Log
    def initialize(type, root_dir, offset)
      @type = type
      @root_dir = root_dir
      @data = YAML.load(read_file) || {}
      @today = Time.now.getlocal(offset).strftime("%F")
    end
    def delta!(target='_total')
      change = 0
      last = nil
      keys = @data.keys
      ckey = target.sub(/_/,'_Δ')
      until keys.empty? do
        k = keys.shift
        total!(k)
        now = @data[k][target] || 0
        change = (last.nil?) ? 0 : now - last
        @data[k].merge!({ckey => change})
        last = now
      end
    end
    def total!(k=nil)
      k ||= @today
      @data[k]["_total"] = @data[k].map {
        |k,v| (/^_/.match?(k)) ? 0 : v
      }.inject(0, :+)
    end
    def data=(h)
      # Don't clobber existing data.
      h.merge(@data[@today].to_h) if @data.keys.include?(@today)
      @data = @data.merge({@today => h})
    end
    def data
      @data
    end
    def write
      fname = self.filename
      FileUtils.mkdir_p(File.dirname(fname))
      f = File.open(fname,'w')
      f.write(@data.to_yaml)
      f.close
    end
    def filename
      File.join([@root_dir, '.verkilo', "#{@type}.yml"])
    end
    private
      def read_file
        contents = "---"
        if File.exist?(self.filename)
          f = File.open(self.filename,'r')
          contents = f.read()
          f.close
        end
        return contents
      end
  end
end
