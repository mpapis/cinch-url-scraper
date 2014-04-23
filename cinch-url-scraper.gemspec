Gem::Specification.new do |s|
  s.name        = 'cinch-url-scraper'
  s.version     = '1.2.1'
  s.summary     =
  s.description = 'A Cinch plugin to get information about posted URLs.'
  s.licenses    = ['LGPLv3']
  s.authors     = ['Michal Papis', 'Richard Banks']
  s.email       = ['mpapis@gmail.com', 'namaste@rawrnet.net']
  s.homepage    = 'https://github.com/mpapis/cinch-url-scraper'
  s.files       = Dir['LICENSE', 'README.md', 'lib/**/*']
  s.required_ruby_version = '>= 1.9.1'
  s.add_dependency("cinch",     "~>2")
  s.add_dependency("mechanize", "~>2")
end
