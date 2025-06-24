require_relative "lib/nova/version"

Gem::Specification.new do |spec|
  spec.name        = "nova"
  spec.version     = Nova::VERSION
  spec.authors     = [ "don-stuckey" ]
  spec.email       = [ "dstuckey@ed.ac.uk" ]
  spec.summary     = "Networked ORCiD Verification & Access"
  spec.license     = "GNU AFFERO GENERAL PUBLIC LICENSE Version 3"
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end
  # spec.add_dependency "rails", ">= 8.0.1"
  spec.add_dependency "rails", ">= 7.0.1"
end
