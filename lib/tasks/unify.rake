require 'fuzzy_match'

task unify: [:environment] do
  Skill.create()
  fz = FuzzyMatch.new(Skill.all, :read => :title)
  Skill.all.map { |skill| skill.title }.each do |skill_title|
    puts "#{fz.find(skill_title)}"
  end
end
