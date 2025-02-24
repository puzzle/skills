require 'rails_helper'

describe :people_skills do
  describe 'People Search', type: :feature, js: true do
    let(:skill) { skills(:rails) }

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'Should return matching entries to page' do
      visit people_skills_path
      fill_out_row(skill.title, 3, 5)
      expect(page).to have_text('Bob Anderson')
      expect(page).to have_text('Wally Allround')
    end

    it 'Should set values of query parameters' do
      visit people_skills_path({ skill_id: [skill.id], level: [3], "interest[0]": 5 })
      expect(page).to have_select("skill_id[]", selected: "Rails", visible: false)
      expect(page).to have_field("level[]", with: 3)
      expect(page).to have_field("interest[0]", with: 5, visible: false)
    end

    it 'Should return add skill to search message if skill id is not given' do
      visit people_skills_path({ level: [3], "interest[0]": 5 })
      expect(page).to have_field("level[]", with: 3)
      expect(page).to have_field("interest[0]", with: 5, visible: false)
      expect(page).to have_text("Keine Resultate gefunden, fügen Sie einen Skill zur Suche hinzu.")
    end

    it 'Should return user which matches filters' do
      visit(people_skills_path)
      fill_out_row("JUnit", 5, 3)
      add_and_fill_out_row("Rails", 4, 5)
      add_and_fill_out_row("ember", 5, 4)
      add_and_fill_out_row("Bash", 5, 2)
      add_and_fill_out_row("cunit", 5, 2)

      expect(page).to have_text("Wally Allround")
    end

    it 'Should return no results if no user matches filters' do
      visit(people_skills_path)
      skill = "Bash"
      fill_out_row(skill, 5, 3)
      expect(page).to have_text("Keine Resultate gefunden, mit dem Skill #{skill} auf dem Level Experte oder höher und dem Interesse 3 oder grösser.")
    end

    it 'Should return no results if no user matches multiple filters' do
      visit(people_skills_path)
      skill1 = "Bash"
      skill2 = "Rails"
      fill_out_row(skill1, 5, 3)
      add_and_fill_out_row(skill2, 1, 4)
      expect(page).to have_text("Keine Resultate gefunden, mit dem Skill #{skill1} auf dem Level Experte oder höher und dem Interesse 3 oder grösser und Mit dem Skill #{skill2} auf dem Level Azubi oder höher und dem Interesse 4 oder grösser.")
    end

    it 'Should be able to remove filter row and switch results accordingly' do
      visit(people_skills_path)

      # set skills in filters
      fill_out_row("ember", 1, 1)

      expect(page).to have_text("Alice Mante")
      expect(page).to have_text("Hope Sunday")
      expect(page).to have_text("Wally Allround")

      # add skill filter
      add_and_fill_out_row("cunit", 1, 1)

      expect(page).to_not have_text("Alice Mante")
      expect(page).to have_text("Hope Sunday")
      expect(page).to have_text("Wally Allround")

      # remove skill filter
      page.find('#remove-row-2').click
      expect(page).to have_text("Alice Mante")
      expect(page).to have_text("Wally Allround")
      expect(page).to have_text("Hope Sunday")
    end
  end

  def add_and_fill_out_row(skill, level, interest)
    old_row_number = last_row[:id][-1, 1].to_i
    click_link(t("people_skills.global.link.add"))

    new_row_id = "filter-row-#{old_row_number + 1}"
    expect(page).to have_selector("[id='#{new_row_id}']")

    fill_out_row(skill, level, interest)
  end

  def fill_out_row(skill, level, interest)
    row_selector = "##{last_row[:id]}"
    within row_selector do
      select_id = find('select', visible: false)[:id]
      select_from_slim_select("#{row_selector} [id='#{select_id}']", skill)
    end

    within row_selector do
      # Tests are flaky in firefox
      sleep 0.3
      find('input[type="range"]').set(level)
    end

    within row_selector do
      id = find("[id$='star-label#{interest}']")[:for]
      # Tests are flaky in firefox
      sleep 0.3
      choose(id, allow_label_click: true)
    end
  end

  def last_row
    page.all("[id^='filter-row-']").sort_by { |row| row[:id] }.last
  end
end
