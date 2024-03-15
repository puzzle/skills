
xdescribe 'Check if people are listed', type: :system do
  it 'shows the people links' do
    visit people_path
    expect(page).to have_css('h1 a[href^="/people/"]', minimum: 2)
  end
end