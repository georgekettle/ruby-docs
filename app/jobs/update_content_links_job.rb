class UpdateContentLinksJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(section:)
    # grab content for each
    html_string = section.rubydocs_says.body.to_s
    # parse with nokogiri
    html = Nokogiri::HTML.fragment(html_string)
    # update original (save section)
    links = html.search('a')
    # change href value
    update_hrefs(section, links)
    # convert back to string
    section.update(rubydocs_says: html.to_s)
  end

  def update_hrefs(section, links)
    regex = /^(?<class_name_1>[A-Z]\w+)*\/*(?<class_name_2>[A-Z]\w+)*\/*(?<class_name_3>[A-Z]\w+)*(\.html)*#*(method-)*(?<method_type>i|c)*(-)*(?<method_name>.+)*$/
    links.each do |link|
      original_href = link.attributes['href'].value
      original_href.gsub!('../', '')
      p original_href
      match = original_href.match(regex)
      if match
        link.attributes['href'].value = (if match[:method_type] && match[:method_name] && match[:class_name_1]
                                          build_link_method_with_klass(section, match)
                                        elsif match[:method_type] && match[:method_name] && match[:class_name_1].nil?
                                          build_link_method_without_klass(section, match)
                                        elsif match[:class_name_1]
                                          build_link_only_klass(section, original_href)
                                        end) || original_href
      end
    end
  end

  def build_link_method_without_klass(section, match)
    klass = section.klass
    method_name = match[:method_name] == "3D-3D" ? "==" : match[:method_name]
    link_section = Section.find_by(name: method_name, category: convert_method_type(match[:method_type]), klass: klass)
    section_path(link_section) if link_section
  end

  def build_link_method_with_klass(section, match)
    p match
    p [match[:class_name_1], match[:class_name_2], match[:class_name_3]]
    klass_names = [match[:class_name_1], match[:class_name_2], match[:class_name_3]].compact
    klass_name = klass_names.join('::')
    p klass_name
    klass = Klass.find_by(name: klass_name, version: section.version)
    klass_path(klass) if klass
  end

  def build_link_only_klass(section, original_href)
    klass_name = original_href.gsub(/\.html.*/, '').gsub('/', '::')
    klass = Klass.find_by(name: klass_name, version: section.version)
    klass_path(klass) if klass
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
