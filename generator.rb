require 'tmpdir'
require 'nokogiri'
require 'fileutils'
require 'erb'

# Generates the ePub file
module Generator
  SKELETON_DIR = './skeleton'
  TEMPLATES_DIR = './templates'

  def self.build_book(document, output_path)
    @title = document.title
    @authors = document.authors.join(', ')
    @images = [] # TODO

    @working_directory = create_working_directory

    create_directory_skeleton
    p 'Creating manifest...'
    create_manifest
    p 'Creating table of contents...'
    create_table_of_contents
    p 'Saving as ePub to ' + output_path
    save_as_epub(output_path)
    perform_cleanup
  end

  private

  def self.create_working_directory
    Dir.mktmpdir 'epublisher'
  end

  # Creates a skeleton needed for an epub file
  def self.create_directory_skeleton
    FileUtils.cp_r(SKELETON_DIR + '/.', @working_directory)
  end

  # Generates the ePub manifest XML file
  def self.create_manifest
    create_file_from_template('content.opf.erb', 'OEBPS/content.opf')
  end

  # Generates table of contents
  def self.create_table_of_contents
    create_file_from_template('toc.ncx.erb', 'OEBPS/toc.ncx')
  end

  # Saves the directory structure as an epub file
  def self.save_as_epub(output_path)
    Dir.chdir @working_directory do
      # ZIP up the file with no compression
      system "zip -r -0 -q output.epub ."
    end
    FileUtils.mv File.join(@working_directory, 'output.epub'), output_path
  end

  # Remove the working directory
  def self.perform_cleanup
    FileUtils.rm_rf @working_directory
  end

  # Generates a file from an (ERB) template
  def self.create_file_from_template(template_name, target_path)
    output = File.open(File.join(@working_directory, target_path), 'w')
    template_path = File.join(TEMPLATES_DIR, template_name)
    output << ERB.new(File.open(template_path).read).result(binding)
    output.close
  end
end
