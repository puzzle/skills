require 'did_you_mean/spell_checker'

task unify: [:environment] do
  skills = Skill.all
  spell_checker = DidYouMean::SpellChecker.new(dictionary: skills.pluck(:title))
  matches = ""
  skills.each do |skill|
    spell_checker.correct(skill.title).each do |match_title|
      match = skills.find_by(title: match_title)
      unless matches.include?(duplicate_sentence(match, skill)) # To check if it was already matched the otherway
        matches += duplicate_sentence(skill, match)
      end
    end
  end
  puts matches
end

def duplicate_sentence(skill, match)
  "Possible duplicates detected: #{skill.title} (id: #{skill.id}) matched: #{match.title} (id: #{match.id}).\n"
end
