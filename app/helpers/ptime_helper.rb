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

  def fetch_data_of_ptime_employees_by_provider
    ptime_providers.each_with_object({}) do |provider_data, hash|
      ptime_employees = Ptime::Client.new(provider_data)
                                     .request(:get, 'employees', { per_page: MAX_PAGE_SIZE })
      hash[provider_data['COMPANY_IDENTIFIER']] = ptime_employees
    end
  end

  def update_failed_names_message(failed_names_by_provider, locale = nil)
    failed_names_by_provider.map do |provider, names|
      if names.any?
        I18n.t('admin.manual_ptime_sync.manual_sync.names_by_provider',
               names: names.to_sentence(locale:), provider:, locale:)
      end
    end.compact.to_sentence(locale:)
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
    validate_company_identifier_not_ex_mitarbeiter
    validate_company_identifiers_exist
  end

  def validate_company_identifiers_unique
    unless @company_identifiers.length == @company_identifiers.uniq.length
      raise PtimeExceptions::InvalidProviderConfig, 'Company identifiers have to be unique'
    end
  end

  def validate_company_identifier_not_ex_mitarbeiter
    unless @company_identifiers.all? { |cid| cid != 'Ex-Mitarbeiter' }
      raise PtimeExceptions::InvalidProviderConfig,
            'Company identifiers cannot be "Ex-Mitarbeiter"'
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
