module Funky
  class Post < GraphRootNode
    # @return [String] the type of post.
    def type
      data[:type]
    end

    # @return [DateTime] the created time of the post.
    def created_time
      DateTime.parse data[:created_time]
    end
  end
end
