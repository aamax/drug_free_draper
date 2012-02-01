module ApplicationHelper
  def title
    base_title = "Drug Free Draper"
    if @title.nil?
      base_title
    else 
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.jpeg", :alt => "LOGO",
                             :class => "headerbanner")  
  end
    
end
