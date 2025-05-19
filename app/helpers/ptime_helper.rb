module PtimeHelper
  def employee_full_name(ptime_employee)
    "#{ptime_employee[:firstname]} #{ptime_employee[:lastname]}"
  end

  def ptime_providers
    @provider_configs = ENV.filter { |env_var| env_var.start_with?('PTIME_PROVIDER') }
                           .sort
                           .to_h
                           .each_slice(4)
                           .map do |config|
      config.to_h.transform_keys { |key| key.sub(/^PTIME_PROVIDER_[0-9]+_/, '') }
    end

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
    provider_configs_valid = @provider_configs.map do |config|
      config.keys.sort == %w[API_PASSWORD API_USERNAME BASE_URL COMPANY_IDENTIFIER]
    end.all?

    unless provider_configs_valid
      raise PtimeExceptions::InvalidProviderConfig,
            'A config is missing or named wrongly. Make sure that every config option is
             set for every provider.'.squish
    end
  end

  def validate_ptime_company_identifiers
    @company_identifiers = @provider_configs.pluck('COMPANY_IDENTIFIER')

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
