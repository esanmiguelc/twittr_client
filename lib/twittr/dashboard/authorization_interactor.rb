module Twittr
  class AuthorizationInteractor
    def initialize(options)
      @session = options[:session]
    end

    def execute(on_success, on_fail)
      if session['screen_name'].nil?
        on_fail.call
      else
        on_success.call
      end
    end

    private

    attr_reader :session
  end
end
