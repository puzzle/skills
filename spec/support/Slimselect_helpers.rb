module SlimselectHelpers
  def select_from_slim_select(id, option, create_if_missing=false)
    open_slim_select(id)
    search_in_slim_select(option)
    if(create_if_missing)
      find('div.ss-addable').click
    else
      find('div.ss-option:not(.ss-disabled)', text: option).click
    end
    expect(page).to have_select(id, selected: option, visible: false)
    expect(page).to have_selector '.ss-main .ss-values .ss-single', text: option
  end

  def check_options_from_slim_select(id, options)
    open_slim_select(id)
    find('div.ss-search input[type="search"]').fill_in with: option
    if(create_if_missing)
      find('div.ss-addable').click
    else
      find('div.ss-option:not(.ss-disabled)', text: option).click
    end
    expect(page).to have_select(id, selected: option, visible: false)
  end

  def open_slim_select(id)
    find_slim_select(id).click
  end

  def find_slim_select(skill_id)
    expect(page).to have_selector("##{skill_id}", visible: false)
    find("##{skill_id}", visible: false).find(:xpath, '..').find(".ss-main")
  end

  def search_in_slim_select(option)
    find('div.ss-search input[type="search"]').fill_in with: option
  end
end
