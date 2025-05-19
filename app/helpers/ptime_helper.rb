module PtimeHelper
  def employee_full_name(ptime_employee)
    "#{ptime_employee[:firstname]} #{ptime_employee[:lastname]}"
  end

  def ptime_providers
    @provider_configs = ENV.filter { |env_var| env_var.start_with?('PTIME_PROVIDER') }
                           .each_slice(4)
                           .map(&:to_h)

    validate_ptime_provider_configs

    @provider_configs
  end

  MAX_PAGE_SIZE = 1000

  private

  def validate_ptime_provider_configs
    validate_number_of_ptime_provider_configs
    validate_ptime_company_identifiers
  end

  def validate_number_of_ptime_provider_configs
    provider_config_valid = @provider_configs.map.with_index do |config, i|
      config.keys.sort ==
        %W[PTIME_PROVIDER_#{i}_API_PASSWORD PTIME_PROVIDER_#{i}_API_USERNAME
           PTIME_PROVIDER_#{i}_BASE_URL PTIME_PROVIDER_#{i}_COMPANY_IDENTIFIER]
    end.all?

    unless provider_config_valid
      raise PtimeExceptions::InvalidProviderConfig,
            'A config is missing or wrongly named. Make sure that every config option is
             set for every provider.'.squeeze
    end
  end

  def validate_ptime_company_identifiers
    @company_identifiers = @provider_configs.filter do |env_var|
      env_var.include?('COMPANY_IDENTIFIER')
    end

    validate_company_identifiers_unique
    validate_company_identifiers_exist
  end

  def validate_company_identifiers_unique
    unless @company_identifiers.length == @company_identifiers.uniq.length
      raise PtimeExceptions::InvalidProviderConfig, 'Company identifiers have to be unique'
    end
  end

  def validate_company_identifiers_exist
    @company_identifiers.each do |company_identifier|
      unless Company.exists?(name: company_identifier)
        raise PtimeExceptions::InvalidProviderConfig,
              "The company with the identifier #{company_identifier} does not exist"
      end
    end
  end
end
