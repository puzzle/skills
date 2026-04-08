require 'rails_helper'

describe SortHelper, type: :helper do
  def expected_direction(records, direction)
    direction == 'asc' ? records : records.reverse
  end

  describe 'Sort people_skills' do
    let(:search_results) do
      [
        [people_skills(:bob_rails)],
        [people_skills(:alice_junit), people_skills(:alice_rails)]
      ]
    end

    before do
      helper.instance_variable_set(:@search_results, search_results)
    end

    it 'sorts people_skills by match count when no sort params are given' do
      allow(helper).to receive(:params).and_return({})
      expect(helper.people_skills).to eq([
                                           [people_skills(:alice_junit), people_skills(:alice_rails)],
                                           [people_skills(:bob_rails)]
                                         ])
    end

    %w[asc desc].each do |sort_dir|
      it "should sort people_skills correctly by name #{sort_dir}" do
        allow(helper).to receive(:params).and_return({ sort: 'name', sort_dir: sort_dir })
        search_results.sort_by! { |people_skills|
          people_skills[0].person.name.to_s.downcase
        }
        expect(helper.people_skills).to eq(expected_direction(search_results, sort_dir))
      end

      %w[level interest certificate core_competence].each do |attr|
        it "should sort people_skills correctly by #{attr} #{sort_dir}" do
          allow(helper).to receive(:params).and_return({ sort: attr, sort_dir: sort_dir })
          search_results.sort_by! { |people_skills| people_skills[0][attr].to_s.downcase }
          expect(helper.people_skills).to eq(expected_direction(search_results, sort_dir))
        end
      end
    end
  end

  describe 'Sort skills' do
    let(:skills) { Skill.all }
    let(:member_count) do
      PeopleSkill
        .where.not(interest: 0)
        .or(PeopleSkill.where.not(level: 0))
        .group('skill_id')
        .count
    end

    before do
      helper.instance_variable_set(:@skills, skills)
      helper.instance_variable_set(:@member_counts, member_count)
    end

    %w[asc desc].each do |sort_dir|
      %w[title default_set radar portfolio].each do |attr|
        it "should sort skills correctly by #{attr} #{sort_dir}" do
          allow(helper).to receive(:params).and_return({ sort: attr, sort_dir: sort_dir })
          sorted_skills = skills.to_a.sort_by { |skill| skill[attr].to_s.downcase }
          expect(helper.skills).to eq(expected_direction(sorted_skills, sort_dir))
        end
      end

      it "should sort skills correctly by category #{sort_dir}" do
        allow(helper).to receive(:params).and_return({ sort: "category", sort_dir: sort_dir })
        sorted_skills = skills.to_a.sort_by { |s| s.category.parent.title.downcase }
        expect(helper.skills).to eq(expected_direction(sorted_skills, sort_dir))
      end
      it "should sort skills correctly by subcategory #{sort_dir}" do
        allow(helper).to receive(:params).and_return({ sort: "subcategory", sort_dir: sort_dir })
        sorted_skills = skills.to_a.sort_by { |s| s.category.title.downcase }
        expect(helper.skills).to eq(expected_direction(sorted_skills, sort_dir))
      end
      it "should sort skills correctly by members#{sort_dir}" do
        allow(helper).to receive(:params).and_return({ sort: "members", sort_dir: sort_dir })
        sorted_skills = skills.to_a.sort_by { |s| helper.send(:filter_by_rated, s).count }
        expect(helper.skills).to eq(expected_direction(sorted_skills, sort_dir))
      end
    end
  end
end
