module PersonRelationsHelpers
  #link_name -> The link text that is displayed on the view
  #form_field_id -> The id of an element that is only in the form (used to determine when the form has finished loading)
  def open_create_form(obj_class)
    element_id = dom_id(obj_class.new)
    link = findByTurboFrameId(element_id)
    scroll_to(link, align: :center)
    link.click
    n_children = find("##{element_id}").all("*").count
    expect(n_children).to be > 0
  end

  def open_edit_form(element)
    element_id = dom_id(element)
    html_element = findByTurboFrameId(element_id)
    scroll_to(html_element, align: :center)
    html_element.click
    n_children = find("##{element_id}").all("*").count
    expect(n_children).to be > 0
  end

  def findByTurboFrameId(id)
    find("a[data-turbo-frame='#{id}']")
  end
end