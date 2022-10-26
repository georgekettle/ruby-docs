class UpdateContentLinksJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(section_id:, **_args)
    section = Section.find(section_id)
    # loop through sections
    # grab content for each
    html_string = section.rubydocs_says.body.to_s
    # parse with nokogiri
    html = Nokogiri::HTML.fragment(html_string)
    # update original (save section)
    links = html.search('a')
    # change href value
    update_hrefs(section, links)
    # convert back to string

    links.map{|link| link.attributes['href'].value}
  end

  def update_hrefs(section, links)
    regex = /(?<class_name>\w+)\.html#*(method-)*(?<method_type>i|c)*(-)*(?<method_name>.+)*/
    links.each do |link|
      original_href = link.attributes['href'].value
      match = original_href.match(regex)
      klass = Klass.find_by(name: match[:class_name], version: section.version)
      link_section = Section.find_by(name: match[:method_name], category: convert_method_type(match[:method_type]), klass: klass)
      
      if link_section
        link.attributes['href'].value = section_path(link_section)
      elsif klass
        link.attributes['href'].value = klass_path(klass)
      end
    end
  end

  def convert_method_type(method_type)
    case method_type
    when 'i' then 'instance_method'
    when 'c' then 'class_method'
    else
      nil
    end
  end
end
