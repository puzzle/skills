require 'rails_helper'

describe 'Department Skill Snapshots', type: :feature, js: true do
  before(:each) do
    admin = auth_users(:admin)
    login_as(admin, scope: :auth_user)
    visit department_skill_snapshots_path
  end

  it 'Should display all selects with the corresponding labels and the canvas chart' do
    expect(page).to have_content('Organisationseinheit')
    expect(page).to have_content('Skill')
    expect(page).to have_content('Jahr')
    expect(page).to have_field('department_id', visible: :hidden)
    expect(page).to have_field('skill_id', visible: :hidden)

    expect(page).to have_select('year')
    expect(page).to have_select('chart_type')

    expect(page).to have_selector("canvas")
  end

  it 'restyles the chart when the theme changes, without a page reload' do
    canvas_image = -> { page.evaluate_script("document.querySelector('canvas').toDataURL()") }
    before_image = canvas_image.call

    # Cycle the theme to dark (auto -> light -> dark) via the navbar toggle.
    toggle = find("[data-controller='theme']")
    toggle.click
    toggle.click
    expect(page).to have_css("html[data-bs-theme='dark']")

    # The chart controller listens for the theme change and rebuilds with the
    # dark palette, so the canvas must repaint to different pixels (the previous
    # bug left the old colours in place until a manual reload).
    after_image = before_image
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop do
        after_image = canvas_image.call
        break if after_image != before_image

        sleep 0.1
      end
    end

    expect(after_image).not_to eq(before_image)
  end
end
