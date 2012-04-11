module OmniConfig
  # Error thrown when a loader has a dependency that cannot be
  # found. It is not reasonable to package every load dependency with
  # OmniConfig so this is raised at runtime if there are any issues.
  class LoaderDependencyError < StandardError; end

  # Error thrown when a loader fails to properly load for some reason.
  class LoaderLoadError < StandardError; end

  # Error thrown when a type from the raw configuration is not
  # correct.
  class TypeError < StandardError; end

  # Error thrown when validation of the settings fails.
  class InvalidConfiguration < StandardError
    attr_reader :errors
    attr_reader :settings

    def initialize(settings, errors, message)
      super(message)

      @message  = message
      @errors   = errors
      @settings = settings
    end

    def to_s
      result = "#{@message}\n\n"

      @errors.each do |error|
        result += "* #{error}\n"
      end

      result
    end
  end
end
