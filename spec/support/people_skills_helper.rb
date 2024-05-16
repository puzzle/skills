module PeopleSkillsHelpers
  def select_skill(skill)
    select_from_slim_dropdown("people_skill_skill_attributes_id", skill.title)
    expect(page).to have_select("people_skill_skill_attributes_category_id", selected: skill.category.name_with_parent, visible: false)
  end

  def select_and_create_skill(skill_name, category)
    select_from_slim_dropdown("people_skill_skill_attributes_id", skill_name, category)
    select category.name_with_parent, from: 'people_skill_skill_attributes_category_id'
  end

  def select_level(level)
    fill_in 'people_skill_level', with: level
    validate_skill_level_label(level)
  end

  def select_star_rating(level)
    find("#star-label#{level}").click()
  end

  def validate_people_skill(person, skill_name)
    expect(page).to have_content(skill_name)
    expect(page).to have_content(skill_name)
    skill_div = find("div.people-skill-title", text: skill_name).find(:xpath, '..').find(:xpath, '..')
    people_skill = people_skill_from_skill_name(person, skill_name)

    within skill_div do
      expect(page).to have_field('people_skill_level', with: people_skill.level, disabled: true)
      validate_skill_level_label(people_skill.level)
      validate_interest(people_skill.interest)
      expect(find("#certificate-checkbox").checked?).to eq people_skill.certificate
      expect(find("#core-competence-checkbox").checked?).to eq people_skill.core_competence
    end
  end

  def people_skill_from_skill_name(person, skill_name)
    person.people_skills.joins(:skill).find_by(skills: {title: skill_name })
  end

  def validate_skill_level_label(level)
    skill_level_label = ExpertiseTopicSkillValue.skill_levels.key(level-1)
    expect(page).to have_selector('#skill-level-label', text: /#{skill_level_label}/i)
  end

  def validate_interest(interest)
    expect(page).to have_selector("input[id^='star'][type='radio']:disabled:not(:checked)", visible: false, count: interest)
  end
end
