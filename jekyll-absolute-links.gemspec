# -*- encoding: utf-8 -*-
require File.expand_path("../lib/jekyll-absolute-links/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name      = "jekyll-absolute-links"
  spec.version   = JekyllAbsoluteLinks::VERSION
  spec.authors   = ["Jose Miguel Venegas Mendoza"]
  spec.email     = ["jvenegasmendoza@gmail.com"]
  spec.homepage  = "https://github.com/rukbotto/jekyll-absolute-links"
  spec.license   = "MIT"

  spec.summary       = "Absolute link converter for Jekyll sites."
  spec.description   = <<-DESCRIPTION
    Absolute link converter for Jekyll sites. Crawls the generated HTML files
    in search of relative links and transform them to absolute links by
    prepending the site domain.
  DESCRIPTION

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("jekyll", "~> 3.3")

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
