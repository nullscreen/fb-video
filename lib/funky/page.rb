module Funky
  class Page < FunkyObject

    # @return [String] the username.
    def username
      data[:username]
    end

    # @return [String] the name.
    def name
      data[:name]
    end

    # Fetches the data from Facebook's APIs and instantiates the data
    # into an Array of Funky::Page objects. It can accept one page ID or an
    # array of multiple page IDs.
    #
    # @example Getting one page
    #   id = '10153834590672139'
    #   Funky::Page.where(id: id) # => [#<Funky::Page>]
    # @example Getting multiple videos
    #   ids = ['10154439119663508', '10153834590672139']
    #   Funky::Page.where(id: ids) # => [#<Funky::Page>, #<Funky::Page>]
    #
    # @return [Array<Funky::Page>] multiple instances of Funky::Page objects
    #   containing data obtained by Facebook's APIs.
    def self.where(id:)
      return nil unless id
      instantiate_collection(fetch_and_parse_data Array(id))
    end

  private

    def self.fields
      [
        'name',
        'username'
      ]
    end
  end
end
