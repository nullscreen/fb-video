module Funky
  class URL
    attr_reader :url
    VIDEO_ID_REGEXES = [/videos\/(\d*)/i, /v=(\d*)/i, /\/v.\..*\/(\d*)\b/i]

    def initialize(url)
      @url = url
    end

    def video_id
      return unless url.include? 'facebook.com'
      VIDEO_ID_REGEXES.each do |regex|
        url.match regex
        return $1 unless $1.nil? || $1.empty? || !$1.size.between?(15,17)
      end
      nil
    end
  end
end
