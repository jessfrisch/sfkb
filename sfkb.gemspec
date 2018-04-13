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
  spec.add_dependency 'faraday', '~> 0.12'
  spec.add_dependency 'restforce', '~> 2.5'
  spec.add_dependency 'dotenv', '~> 2.2'
  spec.add_development_dependency 'hipsterhash', '~> 0.0.4'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'minitest-vcr', '~> 1.4'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'rack-test', '~> 0.8'
  spec.add_development_dependency 'simplecov', '~> 0.15'
end
