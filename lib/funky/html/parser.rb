module Funky
  # @api private
  module HTML
    class Parser
      def parse(html:)
        {
          view_count: extract_views_from(html),
          share_count: extract_shares_from(html),
          like_count: extract_likes_from(html),
          comment_count: extract_comments_from(html)
        }
      end

      def extract_shares_from(html)
        html.match(/"sharecount":(.*?),/)
        matched_count $1
      end

      def extract_views_from(html)
        html.match(/<div><\/div><span class="fcg">\D*([\d,.]+)/)
        html.match %r{([\d,.]*?) views from this post} if $1.nil?
        matched_count $1
      end

      def extract_likes_from(html)
        html.match(/"likecount":(\d+),"likecountreduced"/)
        matched_count $1
      end

      def extract_comments_from(html)
        html.match /"commentcount":(.*?),/
        matched_count $1
      end

    private

      def matched_count(matched)
        matched ? matched.delete(',').to_i : nil
      end
    end
  end
end
