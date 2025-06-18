require_relative "lib/nova/version"

Gem::Specification.new do |spec|
  spec.name        = "nova"
  spec.version     = Nova::VERSION
  spec.authors     = [ "don-stuckey" ]
  spec.email       = [ "dstuckey@ed.ac.uk" ]
  spec.homepage    = ""
  spec.summary     = ""
  spec.description = ""
  spec.license     = "GNU AFFERO GENERAL PUBLIC LICENSE Version 3"

  spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.1"
end
