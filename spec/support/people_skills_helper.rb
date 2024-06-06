module PeopleSkillsHelpers
  def select_skill(skill)
    select_from_slim_select("#people_skill_skill_attributes_id", skill.title)
    expect(page).to have_select("people_skill_skill_attributes_category_id", selected: skill.category.name_with_parent, visible: false)
  end

  def select_and_create_skill(skill_name, category)
    select_from_slim_select("#people_skill_skill_attributes_id", skill_name, category)
    select category.name_with_parent, from: 'people_skill_skill_attributes_category_id'
  end

  def select_level(level)
    fill_in 'people_skill_level', with: level
    validate_skill_level_label(level)
  end

  def select_star_rating(level, show= false)
    id = find("[id^='star-label#{level}']")[:for]
    choose(id, allow_label_click: true, disabled: show)
  end

  def validate_people_skill(person, skill_name)
    expect(page).to have_content(skill_name)
    people_skill = people_skill_from_skill_name(person, skill_name)
    skill_div = find("#default-skill-#{people_skill.skill.id}")
    within skill_div do
      expect(page).to have_field('person_people_skills_attributes_0_level', with: people_skill.level)
      validate_skill_level_label(people_skill.level)
      validate_interest(people_skill.interest)
      expect(find("#person_people_skills_attributes_0_certificate").checked?).to eq people_skill.certificate
      expect(find("#person_people_skills_attributes_0_core_competence").checked?).to eq people_skill.core_competence
    end
  end

  def people_skill_from_skill_name(person, skill_name)
    person.people_skills.joins(:skill).find_by(skills: {title: skill_name })
  end

  def validate_skill_level_label(level)
    skill_level_key = ExpertiseTopicSkillValue.skill_levels.key(level-1)
    skill_level_label = I18n.t("people-skills.levels.#{skill_level_key}")
    expect(page).to have_selector('[data-people-skills-target="label"]', text: /#{skill_level_label}/i)
  end

  def validate_interest(interest)
    star_labels = page.find_all("label[id^='star']", visible: false).to_a.reverse
    star_labels.each_with_index do |label, index|
      if index < interest
        expect(label.native.css_value('color')).to eql('rgb(255, 199, 0)')
      else
        expect(label.native.css_value('color')).to eql('rgb(204, 204, 204)')
      end
    end
  end
end
