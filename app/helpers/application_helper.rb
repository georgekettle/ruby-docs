module ApplicationHelper
  def default_meta_tags
    {
    site: 'ruby-docs.org',
      title: 'Ruby Docs',
      reverse: true,
      separator: '|',
      description: 'Better Ruby Documentation',
      keywords: 'ruby, ruby docs, ruby documentation, ruby programming language',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('favicon.png') },
        { href: image_url('icon.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: 'ruby-docs.org',
        title: 'Ruby Docs',
        description: 'Better Ruby Documentation', 
        type: 'website',
        url: request.original_url,
        image: image_url('cover.png')
      }
    }
  end
end
