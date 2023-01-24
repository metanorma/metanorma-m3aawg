require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "asciidoctor"
require "metanorma-m3aawg"
require "metanorma/m3aawg"
require "isodoc/m3aawg/html_convert"
require "isodoc/m3aawg/word_convert"
require "metanorma/standoc/converter"
require "rspec/matchers"
require "equivalent-xml"
require "htmlentities"
require "metanorma"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

OPTIONS = [backend: :m3aawg, header_footer: true, agree_to_terms: true].freeze

def metadata(xml)
  xml.sort.to_h.delete_if do |_k, v|
    v.nil? || (v.respond_to?(:empty?) && v.empty?)
  end
end

def presxml_options
  { semanticxmlinsert: "false" }
end

def strip_guid(xml)
  xml.gsub(%r{ id="_[^"]+"}, ' id="_"')
    .gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(xml)
  HTMLEntities.new.encode(xml, :hexadecimal)
    .gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n")
    .gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<")
    .gsub(/&#x26;/, "&").gsub(/&#x27;/, "'")
    .gsub(/\\u(....)/) do |_s|
    "&#x#{$1.downcase};"
  end
end

def xmlpp(xml)
  c = HTMLEntities.new
  xml &&= xml.split(/(&\S+?;)/).map do |n|
    if /^&\S+?;$/.match?(n)
      c.encode(c.decode(n), :hexadecimal)
    else n
    end
  end.join
  xsl = <<~XSL
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:template match="/">
        <xsl:copy-of select="."/>
      </xsl:template>
    </xsl:stylesheet>
  XSL
  Nokogiri::XSLT(xsl).transform(Nokogiri::XML(xml, &:noblanks))
    .to_xml(indent: 2, encoding: "UTF-8")
    .gsub(%r{<fetched>[^<]+</fetched>}, "<fetched/>")
    .gsub(%r{ schema-version="[^"]+"}, "")
end

ASCIIDOC_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:

HDR

ASCIIDOC_BLANK_HDR_NO_PDF = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:
  :no-pdf:

HDR

VALIDATING_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

HDR

BOILERPLATE =
  HTMLEntities.new.decode(
    File.read(File.join(File.dirname(__FILE__),
                        "..", "lib", "metanorma", "m3aawg", "boilerplate.xml"), encoding: "utf-8")
    .gsub(/\{\{ docyear \}\}/, Date.today.year.to_s)
    .gsub(/<p>/, '<p id="_">')
    .gsub(/<p class="boilerplate-address">/, '<p id="_" class="boilerplate-address">')
    .gsub(/\{% if unpublished %\}.+?\{% endif %\}/m, "")
    .gsub(/\{% if ip_notice_received %\}\{% else %\}not\{% endif %\}/m, ""),
  )

BOILERPLATE_LICENSE = <<~HDR.freeze
  <license-statement>
               <clause>
                 <title>Warning for Drafts</title>
                 <p id='_'>
                   This document is not an M3AAWG Standard. It is distributed for review
                   and comment, and is subject to change without notice and may not be
                   referred to as a Standard. Recipients of this draft are invited to
                   submit, with their comments, notification of any relevant patent
                   rights of which they are aware and to provide supporting
                   documentation.
                 </p>
               </clause>
             </license-statement>
HDR

BLANK_HDR = <<~"HDR".freeze
  <?xml version="1.0" encoding="UTF-8"?>
  <m3d-standard xmlns="https://www.metanorma.org/ns/m3d" type="semantic" version="#{Metanorma::M3AAWG::VERSION}">
  <bibdata type="standard">

   <title language="en" format="text/plain">Document title</title>
   <docidentifier type='M3AAWG'>:#{Time.new.year}</docidentifier>
    <contributor>
      <role type="author"/>
      <organization>
        <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
        <abbreviation>M3AAWG</abbreviation>
      </organization>
    </contributor>
    <contributor>
      <role type="publisher"/>
      <organization>
        <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
        <abbreviation>M3AAWG</abbreviation>
      </organization>
    </contributor>
   <language>en</language>
    <script>Latn</script>
   <status>
           <stage>published</stage>
   </status>

    <copyright>
      <from>#{Time.new.year}</from>
      <owner>
        <organization>
        <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
        <abbreviation>M3AAWG</abbreviation>
        </organization>
      </owner>
    </copyright>
    <ext>
    <doctype>report</doctype>
    </ext>
  </bibdata>
  #{BOILERPLATE}
HDR

HTML_HDR = <<~"HDR".freeze
  <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
  <div class="title-section">
    <p>&#160;</p>
  </div>
  <br/>
  <div class="prefatory-section">
    <p>&#160;</p>
  </div>
  <br/>
  <div class="main-section">
HDR

def mock_pdf
  allow(::Mn2pdf).to receive(:convert) do |url, output, _c, _d|
    FileUtils.cp(url.gsub(/"/, ""), output.gsub(/"/, ""))
  end
end
