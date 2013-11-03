# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |s|
  s.name          = 'dev-pty-screen'
  s.version       = DevPtyScreen::VERSION
  s.date          = '2013-10-13'
  s.summary       = 'VIM screen sharing as the neckbeards intended'

  s.description   =<<HEREDOC
    One user runs the server from with the resposity that you want to work one.
    Clients (including the one who started the server) connect, and can
    interact with the VIM session.
HEREDOC

  s.authors       = [ 'Mark Lorenz' ]
  s.email         = 'markjlorenz@gmail.com'
  s.homepage      = 'http://github.com/dapplebeforedawn'
  s.license       = 'MIT'
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w[ lib lib/server lib/client ]

  s.add_dependency 'celluloid',  '0.15.2'
  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
end
