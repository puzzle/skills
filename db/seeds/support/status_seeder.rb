# encoding: utf-8

class StatusSeeder
  def seed_statuses(status_names)
    status_names.each do |s|
      seed_status(s)
    end
  end

  private

  def seed_status(status_name)
    Status.seed_once(:status) do |s|
      s.status = status_name
    end
  end
end
