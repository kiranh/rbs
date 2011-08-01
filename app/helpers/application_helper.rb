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

  def scotland_states
    ['Aberdeen','Aberdeenshire','Angus','Argyll and Bute','Clackmannanshire','Dumfries and Galloway','East Ayrshire','East Dunbartonshire','East Lothian','Edinburgh','Eilean Siar','Falkirk','Fife','Glasgow','Highland','Inverclyde','Midlothian','Moray','North Ayrshire','North Lanarkshire','Orkney Islands','Perth and Kinross','Renfrewshire','Shetland Islands','South Ayrshire','South Lanarkshire','Stirling','The Scottish Borders','West Dunbartonshire','West Lothian']
  end
end
