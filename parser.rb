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

  # Array of references
  def get_references
    # Remove data that is not interesting (at this time)
    @doc.xpath('//*[@id="references"]/div/ol/li/ul').unlink

    @doc.xpath('//*[@id="references"]/div/ol/li').map do |ref|
      {
        html_id:  ref.attribute('id').value,
        entry:    ref.text
      }
    end
  end

  # Main body of the article (in HTML)
  def get_content
    # Main content nodeset
    content = @doc.at_xpath('//article[1]/section[2]').children

    perform_cleanup
    correct_links

    content.to_html
  end

  private

  # Clean up the main body
  def perform_cleanup
    # TODO For now, remove any boxes or figures
    @doc.css('div .figure, .box-element').unlink

    # Get rid of NAV elements
    @doc.css('nav').unlink
  end

  def correct_links
    # Make references work
    @doc.xpath('//article[1]/section[2]//sup/a').map do |a|
      a.attribute('href').value = 'references.xhtml' + a.attribute('href').value
    end
  end
end
