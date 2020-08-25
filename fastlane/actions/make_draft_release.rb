module Fastlane
  module Actions
    class MakeDraftReleaseAction < Action
      require 'yaml'
      def self.run(params)
        # The last git tag
        last_tag = Actions.last_git_tag_name
        
        UI.success "The last git tag is #{last_tag}"

        # The last project version
        last_version = other_action.get_version_number
        UI.success "The last version is #{last_version}"

        if params[:new_version]
          # Use the given new version number
          new_version = params[:new_version]
        else
          # Bump to a new version number
          version_array = last_version.split('.').map(&:to_i)

          case params[:bump_type]
          when "patch"
            version_array[2] = version_array[2] + 1
            new_version = version_array.join(".")
          when "minor"
            version_array[1] = version_array[1] + 1
            version_array[2] = 0 if version_array[2]
            new_version = version_array.join(".")
          when "major"
            version_array[0] = version_array[0] + 1
            version_array[1] = 0 if version_array[1]
            version_array[2] = 0 if version_array[2]
            new_version = version_array.join(".")
          end
        end

        UI.success "Bump from [#{last_version}] to [#{new_version}]"

        # Extract commits information from git
        commits = other_action.changelog_from_git_commits(
          between: [last_tag, 'HEAD'],
          quiet: true
        )
        commits = commits.split(/\n+/)

        UI.message "#{commits.length} commits are collected:\n\n" + commits.join("\n") + "\n"

        # The draft information
        draft_release = {
          "last" => {
            "tag" => last_tag,
            "version" => other_action.get_version_number,
            "build" => other_action.get_build_number.to_i
          },
          "target" => {
            "tag" => "v#{new_version}",
            "version" => new_version,
            "build" => other_action.number_of_commits
          },
          "commit_messages" => commits,
          "release_message" => commits.map {|v| "* #{v}" }.join("\n")
        }

        # The draft file name
        draft_release_filename = params[:draft_release_filename]

        # Write information to file
        File.open(draft_release_filename, "w") { |file| 
          file.write(draft_release.to_yaml)
        }
        UI.success "The draft-release information is saved to file #{draft_release_filename}"

        return nil
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Generate a draft file for a new release"
      end

      def self.details
        "Generate a draft file used to prepare for a new release"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :draft_release_filename,
                                       env_name: "CST_DRAFT_RELEASE",
                                       description: "The filename of the draft file",
                                       default_value: "DRAFT_RELEASE.yml"),
          FastlaneCore::ConfigItem.new(key: :bump_type,
                                       env_name: "CST_RELEASE_BUMP_TYPE",
                                       description: "The type of this version bump: [patch, minor, major]",
                                       default_value: "patch",
                                       verify_block: proc do |value|
                                        UI.user_error!("Available values are 'patch', 'minor' and 'major'") unless ['patch', 'minor', 'major'].include?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :new_version,
                                       description: "Bump to a given version. If this value is given, the bump_type will be ignored",
                                       optional: true,
                                       verify_block: proc do |value|
                                        UI.user_error! "The given version [#{value}] isn't a valid three-part semantic version number." unless value =~ /^\d+(\.\d+){2}$/
                                       end)
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
