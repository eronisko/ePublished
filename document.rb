require 'rubygems'

require './parser.rb'

class Document
  attr_reader :title, :authors, :abstract

  def initialize
    file = self.class.get_file
    parser = Parser.new(file)
    @title = parser.get_title
    @authors = parser.get_authors
    @abstract = parser.get_abstract

    # TODO remove after we've switched to online
    file.close
  end

  private 

  # Retrieve the file
  def self.get_file
    File.open('./sample.html')
  end

  self.new()
end
