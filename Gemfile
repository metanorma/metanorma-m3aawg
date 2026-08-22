Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# Latest plurimath (org directive): old 0.10.0 pairs badly with mml 2.x
# (requires the removed mml/configuration). Latest pairs with mml 2.x.
gem "plurimath", "~> 0.11.6"
gem "mml", ">= 2.0"
gem "rubocop", "~> 1"
if File.exist? 'Gemfile.devel'
  eval File.read('Gemfile.devel'), nil, 'Gemfile.devel' # rubocop:disable Security/Eval
end
