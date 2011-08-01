module ApplicationHelper
  def show_footer?(cont=nil, act=nil)
    return true
#    if cont || act
#      if cont == "home" && (act == "new" || act == "create")
#        return false
#      end
#    else
#      return true
#    end
  end

  def auto_complete_result(entries, field, phrase = nil)
    return unless entries
    items = entries.map { |entry| content_tag(:li, phrase ? highlight(link_to(entry[field], user_path(entry[field]) ), phrase) : link_to(entry[field], user_path(entry[field]) )) }
    content_tag(:ul, items.uniq.join().html_safe)
  end
end
