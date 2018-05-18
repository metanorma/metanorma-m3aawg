require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "asciidoctor"
require "asciidoctor-m3d"
require "asciidoctor/m3d"
require "asciidoctor/m3d/m3dconvert"
require "asciidoctor/iso/converter"
require "rspec/matchers"
require "equivalent-xml"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def strip_guid(x)
  x.gsub(%r{ id="_[^"]+"}, ' id="_"').gsub(%r{ target="_[^"]+"}, ' target="_"')
end

ASCIIDOC_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:

HDR

VALIDATING_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:

HDR

BLANK_HDR = <<~"HDR"
       <?xml version="1.0" encoding="UTF-8"?>
       <m3d-standard xmlns="https://open.ribose.com/standards/m3d">
       <bibdata type="article">


         <contributor>
           <role type="author"/>
           <organization>
             <name>Ribose</name>
           </organization>
         </contributor>
         <contributor>
           <role type="publisher"/>
           <organization>
             <name>Ribose</name>
           </organization>
         </contributor>

         <script>Latn</script>

         <copyright>
           <from>#{Time.new.year}</from>
           <owner>
             <organization>
               <name>Ribose</name>
             </organization>
           </owner>
         </copyright>
         <editorialgroup>
           <technical-committee/>
         </editorialgroup>
       </bibdata>
HDR

