require 'did_you_mean/spell_checker'

task unify: [:environment] do
  skills = Skill.all
  spell_checker = DidYouMean::SpellChecker.new(dictionary: skills.pluck(:title))
  skills.each do |skill|
    spell_checker.correct(skill.title).each do |match|
      puts "Duplicate of: #{skill.title} id: #{skill.id} Duplicate: #{match} id: #{skills.find_by(title: match).id}"
    end
  end
end
