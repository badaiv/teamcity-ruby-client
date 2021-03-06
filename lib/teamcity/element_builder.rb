module TeamCity
  class ElementBuilder
    def initialize(attributes = {}, &block)
      @payload = attributes

      if block_given?
        @payload['properties'] ||= {}
        @payload['properties']['property'] ||= []

        properties = {}

        yield(properties)

        properties.each do |name, value|
          @payload['properties']['property'] << {
            :name  => name,
            :value => value
          }
        end
      end
    end

    def to_request_body
      @payload.to_json
    end
  end
end
