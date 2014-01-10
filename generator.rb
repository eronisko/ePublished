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
    p 'Creating manifest...'
    create_manifest
    p 'Creating table of contents...'
    create_table_of_contents
    p 'Saving as ePub'
    save_as_epub
    perform_cleanup
  end

  private

  # Creates a skeleton needed for an epub file
  def self.create_directory_skeleton
    target = OUTPUT_DIR + @book_directory
    FileUtils.mkdir_p target
    FileUtils.cp_r(SKELETON_DIR + '/.', target)
  end

  # Generates the ePub manifest XML file
  def self.create_manifest
    create_file_from_template('content.opf.erb', 'OEBPS/content.opf')
  end

  # Generates table of contents
  def self.create_table_of_contents
    create_file_from_template('toc.ncx.erb', '/OEBPS/toc.ncx')
  end

  # Saves the directory structure as an epub file
  def self.save_as_epub
    Dir.chdir File.join(OUTPUT_DIR, @book_directory) do
      # ZIP up the file with no compression
      system "zip -r -0 ../test.epub ."
    end
  end

  # Remove files not needed
  def self.perform_cleanup
  # TODO
  end

  # Generates a file from an (ERB) template
  def self.create_file_from_template(template_name, output_path)
    output = File.open(File.join(OUTPUT_DIR, @book_directory, output_path), 'w')
    template_path = File.join(TEMPLATES_DIR, template_name)
    output << ERB.new(File.open(template_path).read).result(binding)
    output.close
  end
end
