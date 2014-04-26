# encoding: utf-8

module KoreanZipcodeFinder
  module Configuration
    URL = "http://api.poesis.kr/post/search.php?v=1.1"

    attr_accessor :api_key

    def configure
      yield self
    end
  end
end
