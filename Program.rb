require "pathname"

class Program
  def initialize (root, extension)
    @root = root
    @extension = extension
  end

  def unreferencedFiles
    allFiles - referencedFiles
  end

  def allFiles
    paths(@root).keep_if do |file|
      file.to_s.end_with? @extension
    end.map do |file|
      file.to_s.sub(@root, '')
    end
  end

  def referencedFiles
    paths(@root).keep_if do |file|
      file.to_s.end_with? '.ascx', '.aspx'
    end.map do |file|
      File.new(file).map do |line|
        /(\/\w+)+\.#{@extension}/.match(line).to_s
      end
    end.flatten.uniq
  end

  def paths(path)
    Pathname.new(path).children.collect do |child|
      if child.file?
        child
      elsif child.directory?
        paths(child) + [child]
      end
    end.select { |x| x }.flatten(1)
  end
end

root = 'C:\Hcl.Move\Hcl.Move\Development\app\trunk\app\Hcl.Move.Web'
%w{js css txt png gif jpg jpeg}.each do |extension|
  Program.new(root, extension).unreferencedFiles.each { |file| puts file }
end