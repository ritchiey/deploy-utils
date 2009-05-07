#!/usr/bin/ruby

require 'test/unit'
require 'fileutils'
require 'dir_tree'

class TcDirTree < Test::Unit::TestCase

  include FileUtils
  
  def basedir() 'test_dir' end
  def subdir() File.join(basedir, 'subdir'); end
  def some_file() "#{subdir}/some_file.txt"; end


  def setup
    mkdir_p subdir
    cp __FILE__, some_file
    @dir_tree = DirTree.new(basedir)
  end

  def teardown
    #rm_r basedir
  end

  def test_each_node
    nodes = []
    @dir_tree.each_node {|base, path| nodes << File.join(base, path)}
    assert_equal [subdir, some_file], nodes
  end

  def test_link
    other_dir = 'other_dir'
    rm_r other_dir if File.exists? other_dir
    DirTree.link basedir, other_dir
    assert File.directory?("#{other_dir}/subdir")
    assert File.exists?("#{other_dir}/subdir/some_file.txt")
  end

end
