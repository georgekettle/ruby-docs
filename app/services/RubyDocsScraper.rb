class RubyDocsScraper
  def initialize(version)
    @version = version
    @base_url = "https://ruby-doc.org/core-#{@version}"
    html_file = URI.open(@base_url).read
    @nok_doc = Nokogiri::HTML(html_file)
  end

  def call
    # return hash of results from url
    {
      number: @version,
      base_url: @base_url,
      classes: classes
    }
  end

  def classes
    class_names = @nok_doc.search('#class-index .entries .class a').map{ |c| c&.text&.strip }
    class_names.map do |c_name|
      c_name_for_url = c_name.gsub("::", "/")
      url = @base_url + "/#{c_name_for_url}.html"
      html_file = URI.open(url).read
      @class_nok_doc = Nokogiri::HTML(html_file)
      {
        name: c_name,
        summary: class_summary,
        parent: parent,
        methods: methods,
        url: url
      }
    end
  end

  def class_summary
    @class_nok_doc.search('#description p').first&.text
  end

  def parent
    # scrape parent
    @class_nok_doc.search('#parent-class-section .link a').first&.text
  end

  def methods
    # scrape instance_methods
    methods = @class_nok_doc.search('#class-metadata #method-list-section .link-list li a')
    methods.map { |method| build_method(method.text, method.attributes["href"].value) }
  end

  def build_method(name, anchor)
    match_data = name.match(/(?<category>::|#)(?<name>.+)/)
    name = match_data[:name]
    category = (case match_data[:category]
                when '::' then "class_method" 
                when '#' then "instance_method"
                end)
    {
      name: name,
      category: category,
      summary: method_summary(name),
      content: content(name),
      url: anchor
    }
  end

  def method_summary(name)
    summ = @class_nok_doc.search("[id='#{method_id(name)}'] p").first&.text
    if summ.present?
      summ
    else
      @class_nok_doc.search("[id='#{method_id(name)}'] .aliases").first&.text&.strip
    end
  end

  def content(name)
    html = @class_nok_doc.search("[id='#{method_id(name)}'] > div").last
    html.search('p').each{|el| el.name = 'div'} # substitute p tags for div tags (ActionText preference)
    # html.xpath('//@*').remove # remove all attributes
    html.traverse do |node| 
      node.keys.each do |attribute|
        node.delete attribute unless attribute == 'href'
      end
    end
    html.inner_html.strip
  end

  def method_id(name)
    formatted_dashes = name.gsub('-', '2D')
    formatted_method_name = CGI.escape(formatted_dashes).split("%").reject(&:empty?).join('-')
    "#{formatted_method_name}-method"
  end
end