module Funky
  class GraphRootNode
    attr_reader :data

    def initialize(data)
      @data = data
    end

    # @return [String] the object ID.
    def id
      data[:id]
    end

  private

    def self.fetch_and_parse_data(ids)
      if ids.is_a?(Array) && ids.size > 1
        ids.each_slice(50).inject([]) do |total, slice|
          response = Connection::API.batch_request ids: slice, fields: fields
          total += parse response
        end
      else
        id = ids.is_a?(Array) ? ids.first : ids
        parse Connection::API.request(id: id, fields: fields)
      end
    rescue ContentNotFound
      []
    end

    def self.parse(response)
      if response.code == '200'
        body = JSON.parse response.body, symbolize_names: true
        if body.is_a? Array
          body.select{|item| item[:code] == 200}.collect do |item|
            JSON.parse(item[:body], symbolize_names: true)
          end.compact
        else
          [body]
        end
      else
        raise ContentNotFound, "Error #{response.code}: #{response.body}"
      end
    end

    def self.instantiate_collection(items)
      items.collect { |item| new item }
    end
  end
end
