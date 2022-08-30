module KlassHelper
  def klass_path(klass)
    klass_url(klass.version.number, klass.name)
  end
end