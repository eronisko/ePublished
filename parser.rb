require 'nokogiri'

class Parser
  def initialize(file)
    @doc = Nokogiri::HTML(file)
  end

  # Extract title of the article
  def get_title
    @doc.xpath('//article[1]/header/h1').text
  end

  # Extract abstract (HTML)
  def get_abstract
    @doc.xpath('//*[@id="abstract"]/div/p').to_html
  end

  # Array of author names
  def get_authors
    @doc.xpath('//*[@id="content"]/article/header/ul[1]/li/a/span')
      .map {|p| p.text}
  end

  # Main body of the article (in HTML)
  def get_content
    # Main content nodeset
    content = @doc.at_xpath('//article[1]/section[2]').children

    # Remove any boxes or figures (for now)
    @doc.css('div .figure, .box-element').unlink

    content.to_html
  end
end
