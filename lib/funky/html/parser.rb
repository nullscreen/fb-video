module Funky
  module HTML
    class Parser
      def initialize(html:)
        @html = html
      end

      def shares
        @html.match(/"sharecount":(.*?),/)
        matched_count $1
      end

      def views
        @html.match(/<div><\/div><span class="fcg">(.*) Views<\/span>/)
        matched_count $1
      end

      def likes
        @html.match /"likecount":(.*?),/
        matched_count $1
      end

      def comments
        @html.match /"commentcount":(.*?),/
        matched_count $1
      end

    private

      def matched_count(matched)
        matched ? matched.delete(',').to_i : nil
      end
    end
  end
end
