require 'rails_helper'

describe :people_skills do
  describe 'People Search', type: :feature, js: true do
    let(:skill) { skills(:rails).attributes }

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'Should return matching entries to page' do
      visit people_skills_path

      select skill["title"].to_s, from: 'skill_id[]'
      page.find("#row0_star-label5").click(x: 10, y: 10)
      page.first(".form-range").set(3)
      expect(page).to have_text('Bob Anderson')
      expect(page).to have_text('Wally Allround')
    end

    it 'Should set values of query parameters' do
      visit people_skills_path({skill_id: [skill["id"]], level: [3], "interest[0]": 5})
      expect(page).to have_select("skill_id[]", selected: "Rails")
      expect(page).to have_field("level[]", with: 3)
      expect(page).to have_field("interest[0]", with: 5, visible: false)
    end

    it 'Should return no results if skill id is not set' do
      visit people_skills_path({level: [3], "interest[0]": 5})
      expect(page).to have_field("level[]", with: 3)
      expect(page).to have_field("interest[0]", with: 5, visible: false)
      expect(page).to have_text("Keine Resultate")
    end

    it 'Should return user which matches filters' do
      visit(people_skills_path)
      4.times do
        page.find('#add-row-button').click
      end
      expect(page).to have_selector("#filter-row-4", wait: 2)

      # set skills in filters
      expect(page).to have_css("select", count: 5)
      page.all('select')[0].select('JUnit')
      page.all('select')[1].select('Rails')
      page.all('select')[2].select('ember')
      page.all('select')[3].select('Bash')
      page.all('select')[4].select('cunit')

      # set level in filters
      page.all(".form-range")[0].set(5)
      page.all(".form-range")[1].set(4)
      page.all(".form-range")[2].set(5)
      page.all(".form-range")[3].set(5)
      page.all(".form-range")[4].set(5)

      page.find('#row0_star-label3').click(x: 10, y: 10)
      page.find('#row1_star-label5').click(x: 10, y: 10)
      page.find('#row2_star-label4').click(x: 10, y: 10)
      page.find('#row3_star-label2').click(x: 10, y: 10)
      page.find('#row4_star-label2').click(x: 10, y: 10)

      expect(page).to have_text("Wally Allround")
    end

    it 'Should return no results if no user matches filters' do
      visit(people_skills_path)
      4.times do
        page.find('#add-row-button').click
      end
      expect(page).to have_selector("#filter-row-4", wait: 2)

      # set skills in filters
      page.all('select')[0].select('JUnit')
      page.all('select')[1].select('Rails')
      page.all('select')[2].select('ember')
      page.all('select')[3].select('Bash')
      page.all('select')[4].select('cunit')

      # set level in filters
      page.find('#row4_star-label5').click(x: 10, y: 10)
      expect(page).to have_text("Keine Resultate")
    end

    it 'Should be able to remove filter row and switch results accordingly' do
      visit(people_skills_path)
      page.find('#add-row-button').click
      expect(page).to have_selector("#filter-row-1")

      # set skills in filters
      expect(page).to have_css('select', count: 2)
      page.all('select')[0].select('ember', wait: 2)
      expect(page).to have_text("Alice Mante")
      expect(page).to have_text("Wally Allround")
      expect(page).to have_text("Hope Sunday")

      # add skill filter
      page.all('select')[1].select('cunit')
      expect(page).to have_text("Wally Allround")
      expect(page).to have_text("Hope Sunday")
      expect(page).to_not have_text("Alice Mante")

      # remove skill filter
      page.find('#remove-row-1').click
      expect(page).to have_text("Alice Mante")
      expect(page).to have_text("Wally Allround")
      expect(page).to have_text("Hope Sunday")
    end

  end
end
