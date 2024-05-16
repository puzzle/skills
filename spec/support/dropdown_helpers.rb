module DropdownHelpers
  def select_from_slim_dropdown(id, option, create_if_missing=false)
    expect(page).to have_selector("##{id }", visible: false)
    find("##{id}", visible: false).find(:xpath, '..').find(".ss-main").click
    find('div.ss-search input[type="search"]').fill_in with: option
    if(create_if_missing)
      find('div.ss-addable').click
    else
      find('div.ss-option:not(.ss-disabled)', text: option).click
    end
    expect(page).to have_select(id, selected: option, visible: false)
  end
end
