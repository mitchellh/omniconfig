module OmniConfig
  # Records errors for a configuration object.
  #
  # These errors may come from the loader or from the actual validation
  # of the content itself.
  #
  # Note: For now, this is basically a weak wrapper around an Array. In
  # the future I plan on expanding the functionality such that you can add
  # error messages to specific fields and so on.
  class ErrorRecorder
    attr_reader :errors

    def initialize
      @errors = []
    end

    # Adds an error to the recorder.
    #
    # @param [String] message
    def add(message)
      @errors << message
    end

    # Returns true if there are no errors. False otherwise.
    #
    # @return [Boolean]
    def empty?
      @errors.empty?
    end
  end
end
