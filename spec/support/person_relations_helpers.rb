module PersonRelationsHelpers
  #obj_class -> The class of the specific person_relation you want to open the create form for
  def open_create_form(obj_class)
    element_id = dom_id(obj_class.new)
    link = find_by_turbo_frame_id(element_id)
    scroll_to(link, align: :center)
    link.click
    n_children = find("##{element_id}").all("*").count
    expect(n_children).to be > 0
  end

  #element -> The element for which you want to open the edit form (e.g. person.activities.first)
  def open_edit_form(element)
    element_id = dom_id(element)
    html_element = find_by_turbo_frame_id(element_id)
    scroll_to(html_element, align: :center)
    html_element.click
    n_children = find("##{element_id}").all("*").count
    expect(n_children).to be > 0
  end

  def find_by_turbo_frame_id(id)
    find("a[data-turbo-frame='#{id}']")
  end
end