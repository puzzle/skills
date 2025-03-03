module SlimselectHelpers
  def select_from_slim_select(selector, option_text, create_if_missing=false)
    ss_open(selector)
    if create_if_missing
      ss_create(selector, option_text)
    else
      ss_select_text(selector, option_text)
      ss_close(selector)
    end

    select = find(selector, visible: false)
    select_id = select[:id]
    select_parent = select.find(:xpath, '..')

    within select_parent do
      expect(page).to have_select(select_id, selected: option_text, visible: false)
      expect(page).to have_selector '.ss-main .ss-values .ss-single', text: option_text
    end
  end

  def ss_select_index(selector, index)
    option = ss_options(selector)[index]
    option_value = option['value']
    ss_select(selector, option_value)
  end

  def ss_options(selector)
    call(selector, "getData")
  end

  def ss_check_options(selector, options)
    dropdown_options = ss_options(selector).map{|e| e["text"]}
    expect(dropdown_options).to eq options
  end

  private

  def ss_open(selector)
    call(selector, "open")
  end

  def ss_close(selector)
    call(selector, "close")
  end

  def ss_select_text(selector, option_text)
    options = ss_options(selector)
    option_value = options.filter{|e|e["text"] == option_text }.first["value"]
    ss_select(selector, option_value)
  end

  def ss_select(selector, option_value)
    call(selector, "setSelected", option_value)

    # Manually call the beforeChange event because we manually update the slim select object, which doesn't trigger the event callback

    # Check if option_value is a path
    if option_value.starts_with? '/'
      evaluate_script("document.querySelector('#person_id_person').slim.events.beforeChange([{value: '#{option_value}', html: '<a></a>'}])")
    end
  end

  def ss_search(selector, text)
    ss_open(selector)
    call(selector, "search", text)
  end

  def ss_create(selector, option_text)
    ss_search(selector, option_text)
    page.document.find('div.ss-addable').click
  end

  def call(selector, method, *args)
    args = args.map { |a| (a.is_a? Integer) ? a : "'#{a}'"}
    args = args.count > 1 ? args : args.first
    selector = selector.gsub("\"", "\\\\'").gsub("'", "\\\\'")
    script = "document.querySelector('#{selector}').slim.#{method}(#{args})"
    evaluate_script(script)
  end
end
