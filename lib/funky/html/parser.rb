module Funky
  # @api private
  module HTML
    class Parser
      def parse(html:, video_id:)
        {
          view_count: extract_views_from(html),
          share_count: extract_shares_from(html, video_id),
          like_count: extract_likes_from(html),
          comment_count: extract_comments_from(html, video_id)
        }
      end

      def extract_shares_from(html, video_id)
        html.match(/"sharecount":(.*?),/)
        html.match(/sharecount:(\d+),sharecountreduced/) if $1.nil?
        html.match(/sharecount:(\d+),.*sharefbid:"#{video_id}"/) if $1.nil?
        matched_count $1
      end

      def extract_views_from(html)
        html.match(/<div><\/div><span class="fcg">\D*([\d,.]+)/)
        html.match %r{([\d,.]*?) views from this post} if $1.nil?
        html.match /<div class=\"_1vx9\"><span>([\d,.]*?) .*?<\/span><\/div>/ if $1.nil?
        html.match(/postViewCount:"([\d,.]*?)",/) if $1.nil?
        matched_count $1
      end

      def extract_likes_from(html)
        html.match(/"likecount":(\d+),"likecountreduced"/)
        html.match(/likecount:(\d+),likecountreduced/) if $1.nil?
        matched_count $1
      end

      def extract_comments_from(html, video_id)
        html.match /"commentcount":(.*?),/
        html.match(/commentcount:(\d+),commentcountreduced/) if $1.nil?
        html.match /commentcount:(\d+),.*commentstargetfbid:"#{video_id}"/ if $1.nil?
        matched_count $1
      end

    private

      def matched_count(matched)
        matched ? matched.delete(',').to_i : nil
      end
    end
  end
end
