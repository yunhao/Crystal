Pod::Spec.new do |spec|
  spec.name         = "Crystal"
  spec.version      = "1.0.0"
  spec.summary      = "A lightweight and intuitive theme manager for iOS."

  spec.description  = <<-DESC
                        Crystal is a lightweight and intuitive theme manager for iOS. It takes advantage of Swift’s features to provide an easy-to-use interface. With Crystal, you can integrate themes into your app with confidence and flexibility.

                        - **Flexible**: Crystal is compitible with any object, not just built-in UI components. You can use Crystal anywhere.
                        - **Friendly**: Apply themes in a way you're familiar with, and no additional property APIs will make you confused and distracted.
                        - **Simple**: Adding a theme is as simple as creating an instance. It's easy to maintain your themes with Crystal.
                        - **Type Safe**: Take full advantage of swift's type safety. Apply your theme with confidence and benefit from compile-time check.
                    DESC

  spec.homepage     = "https://github.com/yunhao/Crystal"
  spec.screenshots  = "https://raw.githubusercontent.com/yunhao/Crystal/master/Resources/logo.png"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Rhett Tuan" => "rhetttuan@gmail.com" }

  spec.swift_versions = ['5.2']

  spec.ios.deployment_target = "10.0"

  spec.source       = { :git => "https://github.com/yunhao/Crystal.git", :tag => "v#{spec.version}" }

  spec.source_files  = "Sources", "Sources/**/*.{h,m}"

  spec.requires_arc = true
end
