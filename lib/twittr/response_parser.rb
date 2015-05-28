module Twittr
  class ResponseParser

    def initialize(content)
      @content = content
      @parsed_content = {}
    end

    def parse
      @parsed_content = content.split("&").map { |param| param.split("=") }.to_h
    end

    def get_param(value)
      parsed_content[value]
    end

    private

    attr_reader :content, :parsed_content

  end
end
