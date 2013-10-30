Gem::Specification.new do |s|
  s.name          = 'dev-pty-screen'
  s.version       = '0.0.1'
  s.date          = '2013-10-13'
  s.summary       = "VIM screen sharing that doesn't suck"

  s.description   =<<HEREDOC
    One user runs the server from with the resposity that you want to work one.
    Clients (including the one who started the server) connect, and can
    interact with the VIM session."
HEREDOC

  s.authors       = [ "Mark Lorenz" ]
  s.email         = 'markjlorenz@gmail.com'
  s.homepage      = 'http://github.com/dapplebeforedawn'
  s.license       = 'MIT'
  s.files         = Dir.glob("{bin,lib,doc}/**/*")
  s.executables   = %w[ dev-pty-server dev-pty-client ]
  s.require_paths = %w[ lib/server lib/client ]

  s.add_dependency 'celluloid',  '0.15.2'
end
