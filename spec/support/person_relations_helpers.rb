module PersonRelationsHelpers
  #link_name -> The link text that is displayed on the view
  #form_field_id -> The id of an element that is only in the form (used to determine when the form has finished loading)
  def open_create_dialogue(link_text, form_field_element_id)
    link = find_link(link_text)
    scroll_to(link, align: :center)
    link.click
    expect(page).to have_css(form_field_element_id)
  end
end