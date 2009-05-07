#!/usr/bin/ruby

require 'fileutils'

class DirTree

  attr_accessor :base

  def initialize(base)
    self.base = base
  end

  def each_node(&blk)
    @base = Dir.new(@base) unless @base.kind_of?(Dir)
    recurse('', &blk)
  end
  
  def self.link src, dst, options={}
    copy = options[:copy] || []
    FileUtils.mkdir_p dst
    DirTree.new(src).each_node do |base, path|
      src_path = File.join(base, path)
      dst_path = File.join(dst, path)
      if File.directory?(src_path)
        FileUtils.mkdir dst_path
      elsif copy.include?(path)
        FileUtils.cp src_path, dst_path
      else
        FileUtils.link src_path, dst_path
      end
    end
  end


  private

  def recurse(subdir, &blk)
    dir = Dir.new(File.join(@base.path, subdir))
    dir.each do |filename|
      next if filename == '.' or filename == '..'
      path = File.join(subdir, filename)
      full_path = File.join(@base.path, path)
      blk.call @base.path, path
      recurse(path, &blk) if File.directory?(full_path)
    end
  end

end

