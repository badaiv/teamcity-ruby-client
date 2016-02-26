module TeamCity
  class Client
    # Defines methods related to changes.rb
    module Changes

      # HTTP GET

      # List of changes
      #
      # @param options [Hash] list of change locators to filter change results on
      # @return [Array<Hashie::Mash>] of change (empty array if no builds exist)
      def changes(options={})
        url_params = options.empty? ? '' : "?locator=#{locator(options)}"
        response = get("changes#{url_params}")
        response.build
      end

      # Get change details
      #
      # @param options [Hash] option keys, :id => change_id
      # @return [Hashie::Mash] of build details
      def change(options={})
        assert_options(options)
        get("changes/#{locator(options)}")
      end

    end
  end
end
