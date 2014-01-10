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
    @title = document.title
    @authors = document.authors.join(', ')
    @images = [] # TODO

    create_directory_skeleton
    create_manifest
    save_as_epub
    perform_cleanup
  end

  private

  # Creates a skeleton needed for an epub file
  def self.create_directory_skeleton
    target = OUTPUT_DIR + @book_directory
    FileUtils.mkdir_p target
    FileUtils.cp_r SKELETON_DIR + '/.', target, verbose: true
  end

  # Generates the ePub manifest XML file
  def self.create_manifest
    create_file_from_template(
      File.join(TEMPLATES_DIR, 'content.opf.erb'),
      File.join(OUTPUT_DIR, @book_directory, '/OEBPS/content.opf'))
  end

  # Generates table of contents
  def self.create_toc
    # TODO
    #create_file_from_template(
    #  File.join(TEMPLATES_DIR, 'content.opf.erb'),
    #  File.join(OUTPUT_DIR, @book_directory, '/OEBPS/content.opf'))
  end

  # Saves the directory structure as an epub file
  # TODO
  def self.save_as_epub
  # Something like this
  # cd File.join(OUTPUT_DIR, @book_directory)
  # zip -r -0 ../test.epub .

  # Remove files not needed
  def self.perform_cleanup
  # TODO
  end

  # Generates a file from an (ERB) template
  def self.create_file_from_template(path_to_template, output_path)
    output = File.open(output_path, 'w')
    output << ERB.new(File.open(path_to_template).read).result(binding)
    output.close
  end
end
