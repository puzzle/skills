module SlimselectHelpers
  def select_from_slim_select(id, option, create_if_missing=false, search=false)
    toggle_slim_select(id)
    search_in_slim_select(option) if search
    if(create_if_missing)
      page.document.find('div.ss-addable').click
    else
      page.document.find('div.ss-option:not(.ss-disabled)', text: option).click
    end
    expect(page).to have_select(id, selected: option, visible: false)
    expect(page).to have_selector '.ss-main .ss-values .ss-single', text: option
  end

  def select_index_from_slim_select(id, index)
    option = dropdown_options_from_slim_select(id)[index]
    select_from_slim_select(id, option)
  end

  def check_options_from_slim_select(id, options)
    dropdown_options = dropdown_options_from_slim_select(id)
    expect(dropdown_options).to eq options
  end

  def dropdown_options_from_slim_select(id)
    toggle_slim_select(id)
    options = all('.ss-content .ss-list .ss-option').map{|o| o.text}
    toggle_slim_select(id)
    options
  end

  def toggle_slim_select(select_id)
    find_slim_select(select_id).click
  end

  def find_slim_select(select_id)
    expect(page).to have_selector("[id='#{select_id}']", visible: false)
    find("[id='#{select_id}']", visible: false).find(:xpath, '..').find(".ss-main")
  end

  def search_in_slim_select(option)
    page.document.find('div.ss-search input[type="search"]').fill_in with: option
  end
end
