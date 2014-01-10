require 'rubygems'

require './parser.rb'
require './generator.rb'

class Document
  attr_reader :title, :authors, :abstract, :content

  def initialize(source_path, output_path)
    parse(source_path)
    to_epub(output_path)
  end

  private

  # Retrieve the file
  def self.get_file(path)
    File.open(path)
  end

  # Extract data from the file
  def parse(path_to_file)
    file = self.class.get_file(path_to_file)

    parser = Parser.new(file)
    @title = parser.get_title
    @authors = parser.get_authors
    @abstract = parser.get_abstract
    @content = parser.get_content

    # TODO remove after we've switched to online
    file.close
  end

  # Build the file!
  def to_epub(path)
    Generator.build_book(self, path)
  end

  self.new('./sample.html', './output/test.epub')
end
