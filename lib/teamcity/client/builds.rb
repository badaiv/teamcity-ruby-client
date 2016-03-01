module TeamCity
  class Client
    # Defines methods related to builds
    module Builds

      # HTTP GET

      # List of builds
      #
      # @param options [Hash] list of build locators to filter build results on
      # @return [Array<Hashie::Mash>] of builds (empty array if no builds exist)
      def builds(options={})
        url_params = options.empty? ? '' : "?locator=#{locator(options)}"
        response = get("builds#{url_params}")
        response.build
      end

      # List of builds with sinceBuild locator
      # looks like sinceBuild:(number: xxx) doesn't work!!!
      #
      # @param options [Hash] list of build locators to filter build results on
      # @param sinceBuild_options [Hash] list of build locators to filter build results on
      # @return [Array<Hashie::Mash>] of builds (empty array if no builds exist)
      def builds_since(options={}, since_build_options={})
        url_params = options.empty? ? '' : "?locator=#{locator(options)},sinceBuild:(#{locator(since_build_options)})"
        response = get("builds#{url_params}")
        response.build
      end

      # Get build details
      #
      # @param options [Hash] option keys, :id => build_id
      # @return [Hashie::Mash] of build details
      def build(options={})
        assert_options(options)
        get("builds/#{locator(options)}")
      end

      # Get the build tags
      #
      # @param options [Hash] option keys, :id => build_id
      # @return [Array<Hashie::Mash>] or empty array if no tags exist
      def build_tags(options={})
        assert_options(options)
        response = get("builds/#{locator(options)}/tags")
        response.fetch(:tag)
      end

      # Get build statistics
      #
      # @param build_id [String]
      # @return [Array<Hashie::Mash>]
      def build_statistics(build_id)
        response = get("builds/#{build_id}/statistics")
        response['property']
      end

      # Tells you whether or not a build is pinned
      #
      # @param id [String] build to check if it is pinned
      # @return [Boolean] whether the build is pinned or not
      def build_pinned?(id)
        path = "builds/#{id}/pin"
        response = get(path, :accept => :text, :content_type => :text)
        response == 'true'
      end

      # Get build changes
      #
      # @param id [String] build to get list of changes
      # @return [Array<Hashie::Mash>] of changes (empty array if no builds exist)
      def build_changes(id)
        response = get("changes/?locator=build:(id:#{id})")
        response.change
      end

      # Get build related issues
      #
      # @param id [String] build to get list of related issues
      # @return [Array<Hashie::Mash>] of related issues (empty array if no builds exist)
      def build_issues(id)
        response = get("builds/id:#{id}/relatedIssues")
        # response.issueUsage
        response.issueUsage.map{ |i| i.issue}
      end

      # Get build artifacts
      #
      # @param build_id [String]
      # @return [Array<Hashie::Mash>]
      def build_artifacts(build_id)
        response = get("builds/#{build_id}/artifacts")
        response['files']
      end
      
      # HTTP PUT

      # Pin a build
      #
      # @param id [String] build to pin
      # @param comment [String] provide a comment to the pin
      # @return [nil]
      def pin_build(id, comment='')
        path = "builds/#{id}/pin"
        put(path, :accept => :text, :content_type => :text) do |req|
          req.body = comment
        end
        return nil
      end

      # HTTP DELETE

      # Unpin a build
      #
      # @param id [String] build to unpin
      # @return [nil]
      def unpin_build(id)
        path = "builds/#{id}/pin"
        delete(path, :content_type => :text)
      end
    end
  end
end
