Gem::Specification.new do |s|
  s.name = "muxml"
  s.version = "0.0.1"
  s.date = "2015-02-04"
  s.summary = "Map XML to Object"
  s.authors = ["Jovany Leandro G.C"]
  s.email = 'bit4bit@riseup.net'
  s.files = Dir["lib/**/*" , "Rakefile"]
  s.homepage = 'http://bit4bit.github.com'
  s.license = 'MIT'
  s.add_dependency 'rake', '~> 0'
  s.add_development_dependency 'minitest', '4.7.5'
end
