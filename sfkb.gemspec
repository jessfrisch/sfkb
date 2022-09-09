lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'sfkb'
  spec.version = '0.1.3'
  spec.authors = ['JJ Buckley']
  spec.email = ['jj@bjjb.org']
  spec.summary = 'SalesForce Knowledge Base helper library'
  spec.description = <<-DESC
A Ruby library (based on Restforce) for working with the Salesforce Knowledge
Base.
DESC
  spec.homepage = 'https://github.com/bjjb/sfkb'
  spec.license = 'MIT'
  spec.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] +
               Dir['bin/*'] + Dir['exe/*'] +
               ['README.md', 'LICENSE.txt']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'faraday', '~> 1.8'
  spec.add_dependency 'restforce', '~> 5.2'
  spec.add_dependency 'dotenv', '~> 2.7'
  spec.add_development_dependency 'hipsterhash', '~> 0.0.4'
  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'minitest', '~> 5.15'
  spec.add_development_dependency 'vcr', '~> 6.1'
  spec.add_development_dependency 'minitest-vcr', '~> 1.4'
  spec.add_development_dependency 'pry', '~> 0.13'
  spec.add_development_dependency 'byebug', '~> 11.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rack-test', '~> 1.1'
  spec.add_development_dependency 'simplecov', '~> 0.21'
end
