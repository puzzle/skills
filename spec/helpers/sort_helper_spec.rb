require 'rails_helper'

describe SortHelper, type: :helper do

  let(:person1) { people(:alice) }
  let(:person2) { people(:bob) }

  describe "Sort people_skills" do
    let(:search_results) { [
      [people_skills(:alice_bash)],
      [people_skills(:bob_rails)]
    ] }

    before do
      helper.instance_variable_set(:@search_results, search_results)
    end

    %w[asc desc].each do |sort_dir|
      it "should sort people_skills correctly by name #{sort_dir}" do
        allow(helper).to receive(:params).and_return({ sort: 'name', sort_dir: sort_dir })
        search_results.sort_by! { |people_skills|
          people_skills[0].person.name.to_s.downcase
        }
        expect(helper.people_skills).to eq(sort_dir(search_results, sort_dir))
      end

      %w[level interest certificate core_competence].each do |attr|
        it "should sort people_skills correctly by #{attr} #{sort_dir}" do
          allow(helper).to receive(:params).and_return({ sort: attr, sort_dir: sort_dir })
          search_results.sort_by! { |people_skills| people_skills[0][attr].to_s.downcase }
          expect(helper.people_skills).to eq(sort_dir(search_results, sort_dir))
        end
      end
    end
  end

  describe "Sort skills" do
    let(:skills) { Skill.all }

    before do
      helper.instance_variable_set(:@skills, skills)
    end

    %w[asc desc].each do |sort_dir|
      %w[title default_set radar portfolio].each do |attr|
        it "should sort skills correctly by #{attr} #{sort_dir}" do
          allow(helper).to receive(:params).and_return({ sort: attr, sort_dir: sort_dir })
          sorted_skills = skills.to_a.sort_by { |skill| skill[attr].to_s.downcase }
          expect(helper.skills).to eq(sort_dir(sorted_skills, sort_dir))
        end
      end

      it "should sort skills correctly by category #{sort_dir}" do
        allow(helper).to receive(:params).and_return({ sort: "category", sort_dir: sort_dir })
        sorted_skills = skills.to_a.sort_by { |s| s.category.parent.title.downcase }
        expect(helper.skills).to eq(sort_dir(sorted_skills, sort_dir))
      end
      it "should sort skills correctly by subcategory #{sort_dir}" do
        allow(helper).to receive(:params).and_return({ sort: "subcategory", sort_dir: sort_dir })
        sorted_skills = skills.to_a.sort_by { |s| s.category.title.downcase }
        expect(helper.skills).to eq(sort_dir(sorted_skills, sort_dir))
      end
      it "should sort skills correctly by members#{sort_dir}" do
        allow(helper).to receive(:params).and_return({ sort: "members", sort_dir: sort_dir })
        sorted_skills = skills.to_a.sort_by { |s| helper.send(:filter_by_rated, s).count }
        expect(helper.skills).to eq(sort_dir(sorted_skills, sort_dir))
      end
    end
  end

  def sort_dir(array, sort_dir)
    sort_dir == 'asc' ? array : array.reverse
  end
end