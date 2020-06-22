def getBuildFilename(src, ext, repo=nil)
  dst = [
    File.basename((repo.nil?) ? Dir.pwd : repo),
    File.basename(src),
    @today
  ].join('-') + ".#{ext}"
  File.join(["build", dst])
end
