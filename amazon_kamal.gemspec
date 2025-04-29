require_relative "lib/amazon_kamal/version"

Gem::Specification.new do |spec|
  spec.name         = "amazon_kamal"
  spec.version      = AmazonKamal::VERSION
  spec.authors      = [ "Aaron Baldwin", "Brightways Learning" ]
  spec.email        = "baldwina@brightwayslearning.org"
  spec.homepage     = "https://github.com/wwidea/amazon_kamal"
  spec.summary      = "Provision Amazon Linux servers for use with Kamal."
  spec.license      = "MIT"
  spec.files        = Dir["lib/**/*", "MIT-LICENSE", "README.md"]
  spec.executables  = %w[ amazon-kamal ]

  spec.metadata = {
    "homepage_uri"    => spec.homepage,
    "source_code_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = ">= 3.2.0"

  spec.add_dependency "kamal", ">= 2.5"
end
