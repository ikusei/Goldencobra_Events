Goldencobra::Article.class_eval do
  belongs_to :event, :class_name => GoldencobraEvents::Event
    
end

Goldencobra::ArticlesHelper.module_eval do
  def render_article_events(options={})
    if @article && @article.event_id.present? && @article.event && @article.event.active
      depth = @article.event_levels || 0
      class_name = options[:class] || ""
      id_name = options[:id] || ""
      content = ""
      @article.event.children.active.collect do |child|
        content << event_item_helper(child, depth, 1)
      end
      result = content_tag(:ul, raw(content),:id => "#{id_name}", :class => "#{class_name} #{depth} article_events".squeeze(' ').strip)
      return raw(result)
    end
  end 
  
  
  private
  def event_item_helper(child, depth, current_depth)
    child_block = render_child_block(child)
    current_depth = current_depth + 1
    if child.children && (depth == 0 || current_depth <= depth)
      content_level = ""
      child.children.active.each do |subchild|
          content_level << event_item_helper(subchild, depth, current_depth)
      end
      if content_level.present?
        child_block = child_block + content_tag(:ul, raw(content_level), :class => "level_#{current_depth}" )
      end
    end  
    return content_tag(:li, raw(child_block), :class => "article_event_item")
  end
  
  
  def render_child_block(event)
    content = ""
    content << content_tag(:div, raw(event.title), :class=> "title")
    content << content_tag(:div, raw(event.description), :class=> "description")
    content << content_tag(:div, raw(event.external_link), :class=> "external_link")
    content << content_tag(:div, raw(event.max_number_of_participators), :class=> "max_number_of_participators")
    content << content_tag(:div, raw(event.type_of_event), :class=> "type_of_event")
    content << content_tag(:div, raw(event.type_of_registration), :class=> "type_of_registration")
    content << content_tag(:div, raw(event.exclusive), :class=> "exclusive")
    return content_tag(:div, raw(content), :class=>"article_event_content")
  end
    
end

