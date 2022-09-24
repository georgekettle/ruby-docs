module SectionHelper
  def section_path(section)
    section_url(section.version.number, section.klass.name, section.name)
  end
end