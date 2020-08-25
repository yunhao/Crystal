module Fastlane
  module Actions
    class UpdateChangelogAction < Action
      require 'yaml'
      def self.run(params)
        draft_release_filename = params[:draft_release_filename]
        changelog_filename = params[:changelog_filename]

        begin
          draft_release_yaml = YAML.load(
            File.read(draft_release_filename)
          )
        rescue => error
          UI.error "Invalid syntax found in #{draft_release_filename} file"
          UI.user_error! error
        end

        # The new version to release
        target_version = draft_release_yaml["target"]["version"]
        target_tag = draft_release_yaml["target"]["tag"]

        changelog = {
          :tag => target_tag,
          :version => target_version,
          :release_message => draft_release_yaml["release_message"]
        }

        # Generate changelog markdown
        text = "## [v#{changelog[:version]}](https://github.com/yunhao/Crystal/releases/tag/v#{changelog[:version]}) (#{Time.now.strftime("%Y-%m-%d")})\n\n"
        
        body = changelog[:release_message]

        text += body

        # Write to changelog file
        changelog_md = File.read(changelog_filename)
        File.open(changelog_filename, 'w') { |file|
          file.write(changelog_md.sub("=========", "=========\n\n#{text}\n---"))
        }

        return changelog
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Update the changelog file"
      end

      def self.details
        "Update the changelog file from a draft-release file"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :draft_release_filename,
                                       env_name: "CST_DRAFT_RELEASE",
                                       description: "The filename of the draft-release file",
                                       default_value: "DRAFT_RELEASE.yml"),
          FastlaneCore::ConfigItem.new(key: :changelog_filename,
                                       env_name: "CST_CHANGELOG",
                                       description: "The filename of the changelog file",
                                       default_value: "CHANGELOG.md")
        ]
      end

      def self.return_value
        "An object contains changelog infomation."
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
