Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gem 'isodoc',
    git: 'https://github.com/metanorma/isodoc.git',
    branch: 'feature/sassc-gem-dependecey-removal',
    ref: '83b4a0a0814c6c93a4735a3aa0c7870bb825efbb'
gemspec

if File.exist? 'Gemfile.devel'
  eval File.read('Gemfile.devel'), nil, 'Gemfile.devel' # rubocop:disable Security/Eval
end
