class RubyDocsScraper
  def initialize(version)
    @version = version
    @version_url = "https://ruby-doc.org/core-#{@version}"
    html_file = URI.open(@version_url).read
    @nok_doc = Nokogiri::HTML(html_file)
  end

  def call
    # return hash of results from url
    {
      number: @version,
      url: @version_url,
      classes: classes,
      modules: modules
    }
  end

  def classes
    puts "Scraping Classes"
    class_names = @nok_doc.search('#class-index .entries .class a').map{ |c| c&.text&.strip }
    class_names.map do |c_name|
      puts "- #{c_name}"
      c_name_for_url = c_name.gsub("::", "/")
      url = @version_url + "/#{c_name_for_url}.html"
      html_file = URI.open(url).read
      @class_nok_doc = Nokogiri::HTML(html_file)
      {
        name: c_name,
        summary: class_summary,
        parent: parent,
        methods: methods,
        url: url,
        type: "class"
      }
    end
  end

  def modules
    puts "Scraping Modules"
    module_names = @nok_doc.search('#class-index .entries .module a').map{ |m| m&.text&.strip }
    module_names.map do |m_name|
      puts "- #{m_name}"
      m_name_for_url = m_name.gsub("::", "/")
      url = @version_url + "/#{m_name_for_url}.html"
      html_file = URI.open(url).read
      @class_nok_doc = Nokogiri::HTML(html_file)
      {
        name: m_name,
        summary: class_summary,
        parent: parent,
        methods: methods,
        url: url,
        type: "module"
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
    puts "-- #{name}"
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
      source_code: source_code(name),
      content: content(name),
      url: anchor
    }
  end

  def method_summary(name)
    summ = @class_nok_doc.search("[id='#{Section.format_method_name(name)}-method'] p").first&.text
    if summ.present?
      summ
    else
      @class_nok_doc.search("[id='#{Section.format_method_name(name)}-method'] .aliases").first&.text&.strip
    end
  end

  def content(name)
    html = @class_nok_doc.search("[id='#{Section.format_method_name(name)}-method'] > div").last
    html.search('p').each{|el| el.name = 'div'} # substitute p tags for div tags (ActionText preference)
    # remove source code section
    source = @class_nok_doc.search("[id='#{Section.format_method_name(name)}-method'] .method-source-code").first
    source.remove if source
    # remove attributes except href
    html.traverse do |node| 
      node.keys.each do |attribute|
        node.delete attribute unless attribute == 'href'
      end
    end
    html.inner_html.strip
  end

  def source_code(name)
    html = @class_nok_doc.search("[id='#{Section.format_method_name(name)}-method'] .method-source-code pre").first
    if html
      html.set_attribute('data-controller', 'code')
    end
    html&.to_s&.strip
  end
end