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
end
