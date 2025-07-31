require 'rails_helper'

describe :people do
  describe 'People Skills', type: :feature, js: true do
    let(:person) { people(:bob) }

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'Go to people-skills tab of person' do
      bob = people(:bob)
      visit person_path(bob)

      expect(page).to have_css('.nav-link', text: 'Skills', count: 3)
      page.all('.nav-link', text: 'Skills')[1].click
    end

    it 'displays people-skills' do
      # Switch to PeopleSkills tab
      bob = people(:bob)
      visit person_people_skills_path(bob)
      validate_people_skill(bob, "Rails")
    end

    it 'can edit people-skills' do
      # Switch to PeopleSkills tab
      alice = people(:alice)
      visit person_people_skills_path(alice, rating: 1)

      ember = alice.people_skills.first
      within("#skill-div-#{ember.skill.id}") do
        select_star_rating(2)
        select_level(3, "level_#{ember.skill.id}")
      end

      # Check if changes were saved
      alice.people_skills.each do | person_skill |
        validate_people_skill(alice, person_skill.skill.title)
      end
      ember.reload
      expect(ember.level).to eq(3)
      expect(ember.interest).to eq(2)
    end


    it 'interest is changed from 0 when level is not 0 anymore' do
      # Switch to PeopleSkills tab
      alice = people(:alice)
      visit person_people_skills_path(alice, rating: 1)

      bash = people_skills(:alice_bash)
      expect(bash.level).to eq(0)
      expect(bash.interest).to eq(0)
      within("#skill-div-#{bash.skill.id}") do
        select_level(3, "level_#{bash.skill.id}")
      end

      # Check if changes were saved
      alice.people_skills.each do | person_skill |
        validate_people_skill(alice, person_skill.skill.title)
      end
      bash.reload
      expect(bash.level).to eq(3)
      expect(bash.interest).to eq(1)
    end

    it 'can reset people-skills' do
      # Switch to PeopleSkills tab
      alice = people(:alice)
      visit person_people_skills_path(alice, rating: 1)
      ember = alice.people_skills.first
      within("#skill-div-#{ember.skill.id}") do
        click_button("Nicht bewerten")
      end
      # Check if changes were saved
      alice.people_skills.each do | person_skill |
        validate_people_skill(alice, person_skill.skill.title)
      end
      ember.reload
      expect(ember.level).to eq(0)
      expect(ember.interest).to eq(0)
      expect(ember.certificate).to eq(false)
      expect(ember.core_competence).to eq(false)
    end

    it 'should show amount of skills' do
      # Switch to PeopleSkills tab
      alice = people(:alice)
      visit person_people_skills_path(alice, rating: 1)
      expect(page).to have_content('Ruby (2)')
      expect(page).to have_content('Java (1)')
      expect(page).not_to have_content('c (0)')
      expect(page).to have_content('Linux-Engineering (1)')
    end

    it 'should display unweighted label if level is 0' do
      # Switch to PeopleSkills tab
      alice = people(:alice)
      visit person_people_skills_path(alice, rating: 1)
      within('#people-skills') do
        expect(page).to have_content(t('global.people_skills.levels.unweighted'), count: alice.people_skills.where(level: 0, interest: 0).count)
      end
    end
  end

  def not_rated_default_skills(person)
    rated_skills = person.skills
    not_rated_default_skills = Skill.all.filter do |skill|
      skill.default_set && rated_skills.exclude?(skill)
    end

    not_rated_default_skills.map do |skill|
      PeopleSkill.new({ person_id: person.id, skill_id: skill.id, level: 0, interest: 0,
                        certificate: false, core_competence: false })
    end
  end

  describe 'People default Skills', type: :feature, js: true do
    let(:bob) { people(:bob) }

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
      visit person_people_skills_path(bob, rating: 1)
    end

    it 'displays unrated default skills' do
      not_rated_default_skills = not_rated_default_skills(bob)

      expect(page).to have_content("Neue Skills zur Bewertung")
      expect(page).to have_content("(#{not_rated_default_skills.count})")

      within '#default-skills' do
        not_rated_default_skills.each do |person_skill|
          expect(page).to have_content(person_skill.skill.category.parent.title)
          expect(page).to have_content(person_skill.skill.category.title)
          expect(page).to have_content(person_skill.skill.title)
        end

        expect(page).to have_content('Azubi', count: not_rated_default_skills.count)

        expect(not_rated_default_skills.pluck(:interest).all?(&:zero?)).to be(true)

        check_boxes = page.find_all('input[type="checkbox"]')
        expect(check_boxes.count).to eql(not_rated_default_skills.count * 2)
        check_boxes.each do |checkbox|
          expect(checkbox).not_to be_checked
        end
      end
    end

    it 'saves rated default skills' do
      not_rated_default_skills = not_rated_default_skills(bob)
      within '#default-skills' do
        page.first('[name="people_skill[level]"]').set(3)
        page.first(".star3", visible: false).click(x: 10, y: 10)
        page.first('[name="people_skill[certificate]"]').check
        page.first('[name="people_skill[core_competence]"]').check
        click_button("Bewerten")
      end
      if not_rated_default_skills.count > 1
        expect(page).to have_content("(#{not_rated_default_skills.count - 1})")
      else
        expect(page).not_to have_css('#default-skills')
      end
      expect(page).to have_content(not_rated_default_skills.first.skill.title)
      bob_people_skill = bob.people_skills.last
      expect(bob_people_skill.level).to eql(3)
      expect(bob_people_skill.interest).to eql(3)
      expect(bob_people_skill.certificate).to be_truthy
      expect(bob_people_skill.core_competence).to be_truthy
    end

    it 'doesnt save rated default skills that arent filled out' do
      not_rated_default_skills = not_rated_default_skills(bob)
      expect(page).to have_content("(#{not_rated_default_skills.count})")
      within '#default-skills' do
        click_button("Bewerten")
      end
      expect(page).to have_content("(#{not_rated_default_skills.count})")
    end

    it 'saves not rated skills' do
      not_rated_default_skills = not_rated_default_skills(bob)
      skill_id = not_rated_default_skills.first.skill.id
      skill_div = first("#default-skill-#{skill_id}")

      within skill_div do
        select_star_rating(3)
        find('input[value="Nicht bewerten"]').click
      end

      if not_rated_default_skills.count > 1
        expect(page).to have_content("(#{not_rated_default_skills.count - 1})")
      else
        expect(page).not_to have_css('#default-skills')
      end
      expect(page).to have_content(not_rated_default_skills.first.skill.title)
      bob_people_skill = bob.people_skills.last
      expect(bob_people_skill.level).to eql(0)
      expect(bob_people_skill.interest).to eql(0)
      expect(bob_people_skill.certificate).to be_falsey
      expect(bob_people_skill.core_competence).to be_falsey
    end

    it 'hides default skills form when canceling with cancel-button' do
      click_link("Abbrechen")
      expect(page).not_to have_css('#default-skills')
    end

    it 'hides default skills form when canceling with cancel-x' do
      page.find('.icon.icon-close').click
      expect(page).not_to have_css('#default-skills')
    end
  end

  it 'should not refresh view when editing a unrated skill' do
    bob = people(:bob)
    first_unrated_skill = not_rated_default_skills(bob).first.skill
    sign_in auth_users(:user), scope: :auth_user
    visit person_people_skills_path(bob, rating: -1)
    within("#default-skill-#{first_unrated_skill.id}") do
      select_star_rating(2)
      fill_in "level_#{first_unrated_skill.id}", with: 4
      expect(page).to have_content(first_unrated_skill.title)
      visit person_people_skills_path(bob, rating: 0)
      expect(page).to have_content(first_unrated_skill.title)
    end
  end

  describe 'scroll to menu', type: :feature, js: true do
    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'should only show nav items with rated skills' do
      alice = people(:alice)
      visit person_people_skills_path(alice, rating: 1)

      within '.sidebar' do
        expect(page).to have_content('Software-Engineering')
        expect(page).to have_content('System-Engineering')
      end

      find('label[for="rating_0"]').click

      within '.sidebar' do
        expect(page).to have_content('Software-Engineering')
        expect(page).not_to have_content('System-Engineering')
      end

      find('label[for="rating_-1"]').click

      within '.sidebar' do
        expect(page).not_to have_content('Software-Engineering')
        expect(page).to have_content('System-Engineering')
      end
    end

    it 'should add category to scroll-to-menu once a skill of it is rated' do
      alice = people(:alice)
      alice.people_skills.find_by(skill: skills(:bash)).destroy
      skills(:bash).update(default_set: true)
      visit person_people_skills_path(alice, rating: 1)

      within '.sidebar' do
        expect(page).to have_content('Software-Engineering')
        expect(page).not_to have_content('System-Engineering')
      end

      click_button('Bewerten')


      within '.sidebar' do
        expect(page).to have_content('Software-Engineering')
        expect(page).to have_content('System-Engineering')
      end
    end
  end
end
