module PeopleHelper
  def gen_list_selector(model, attr, hsh)
    # given a model (:people), an attribute (:country),
    # and a hash (keys = radio button label name, vals = input value)
    # returns a string which will render to a collection of radio buttons
    html = ''
    list = hsh.sort

    if list.length < 5
      # radio buttons
      html << "<fieldset><legend>#{attr.to_s.capitalize}</legend>"

      list.each do |el|
        html << radio_button(model, attr, el[1])
        html << label(model, attr, el[0])
        html << '<br>'
      end
      html << "</fieldset>"
    else
      # html select element
      html << label(model, attr, attr.to_s.capitalize)
      html << select(model, attr, list, prompt: "Select Country")
      html << '<br>'
    end

    return html.html_safe
  end
  
end
