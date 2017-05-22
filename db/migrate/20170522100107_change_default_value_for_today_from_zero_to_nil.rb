class ChangeDefaultValueForTodayFromZeroToNil < ActiveRecord::Migration[5.0]
  
  CLASSES = [:Activity, :Education, :Project, :AdvancedTraining]

  def up
    CLASSES.each { |c| zero_to_nil(c)}
  end

  def down
    CLASSES.each { |c| nil_to_zero(c)}
  end

  private

  def zero_to_nil(class_name)
    change_format(class_name, nil, 0)
  end

  def nil_to_zero(class_name)
    change_format(class_name, 0, nil)
  end

  def change_format(class_name, new, old)
    class_name.to_s.constantize.where(year_to: old).find_each do |e|
      e.update_attributes(year_to: new)
    end
  end
end
