module ActionTextCode
  def to_html
    fragment.replace("pre") do |pre|
      pre["data-controller"] = "code"
      pre.inner_html = "<code class='language-ruby'>#{pre.inner_html}</code>"
      pre
    end.to_html
  end
end

ActiveSupport.on_load :action_text_content do
  self.prepend ActionTextCode
end

ActionText::ContentHelper.allowed_attributes += ["data-controller"]