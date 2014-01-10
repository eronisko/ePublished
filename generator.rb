require 'nokogiri'
require 'fileutils'
require 'erb'

# Generates the ePub file
module Generator
  SKELETON_DIR = './skeleton'
  TEMPLATES_DIR = './templates'
  OUTPUT_DIR = './output'
  @book_directory = '/test'

  def self.build_book(document)
    create_directory_skeleton

    #create_manifest
  end

  private

  # Creates a skeleton needed for an epub file
  def self.create_directory_skeleton
    target = OUTPUT_DIR + @book_directory
    FileUtils.mkdir_p target
    FileUtils.cp_r SKELETON_DIR + '/', target, verbose: true
  end

  # Generates the ePub manifest XML file
  def self.create_manifest
    create_file_from_template(
      TEMPLATES_DIR + 'content.opf.erb', 
      OUTPUT_DIR + @book_directory + '/OEBPS/content.opf')
  end

  # Generates a file from an (ERB) template
  def self.create_file_from_template(path_to_template, output_path)
    output = File.open(output_path)
    output << ERB.new(File.open(path_to_template).read).result
    output.close
  end
end
