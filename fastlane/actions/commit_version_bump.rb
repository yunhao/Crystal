module Fastlane
  module Actions
    class CommitVersionBumpAction < Action
      def self.run(params)
        Action.sh "git add -A"
        Actions.sh "git commit -am \"#{params[:message]}\""
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Commit version bump"
      end

      def self.details
        "Create a commit with a message for version bump"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :message,
                                       env_name: "CST_COMMIT_VERSION_BUMP_MESSAGE",
                                       description: "The commit message that should be used",
                                       is_string: true)
        ]
      end

      def self.authors
        ["yunhao"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
