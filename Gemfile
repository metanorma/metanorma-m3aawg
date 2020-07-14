Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gem 'isodoc',
    git: 'https://github.com/metanorma/isodoc.git',
    branch: 'feature/sassc-gem-dependecey-removal',
    ref: 'b6eca615ecbfde2e7f3f1ae6ec82a89b2db7d612'
gemspec

if File.exist? 'Gemfile.devel'
  eval File.read('Gemfile.devel'), nil, 'Gemfile.devel' # rubocop:disable Security/Eval
end
