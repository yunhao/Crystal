module Fastlane
  module Actions
    class ValidateDraftReleaseAction < Action
      def self.run(params)
        # The draft-release yaml file
        begin
          draft_release_yaml = YAML.load(
            File.read(params[:draft_release_filename])
          )
        rescue
          UI.user_error! "The draft-release file not found. Use `fastlane run draft_release` to generate a draft file"
        end
        
        last_version = draft_release_yaml["last"]["version"]
        target_version = draft_release_yaml["target"]["version"]

        validate_version_format(last_version)
        validate_version_format(target_version)

        # Version compare
        if Gem::Version.new(target_version) <= Gem::Version.new(last_version)
          UI.error "The draft-release information is invalid. Check the #{params[:draft_release_filename]} file"
          UI.user_error! "You can not release a new version [#{target_version}] which is equal to or less than the last released version [#{last_version}]" 
        end

        UI.message "Validate draft release ..."
        UI.success "Tag and Version:"
        UI.message "  Last   -> %11s - %s" % ["tag #{draft_release_yaml["last"]["tag"]}", "version #{last_version}"]
        UI.message "  Target -> %11s - %s" % ["tag #{draft_release_yaml["target"]["tag"]}", "version #{target_version}"]

        UI.success "Release Message:"
        draft_release_yaml["release_message"].split("\n").map { |line|
          UI.message "  " + line
        }

        return draft_release_yaml
      end

      def self.validate_version_format(version)
        UI.user_error! "The given version [#{version}] isn't a valid three-part semantic version number." unless version =~ /^\d+(\.\d+){2}$/
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Validate the draft-release file"
      end

      def self.details
        "Check if the draft-release information is valid"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :draft_release_filename,
                                       env_name: "CST_DRAFT_RELEASE",
                                       description: "The filename of the draft file",
                                       default_value: "DRAFT_RELEASE.yml")
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
