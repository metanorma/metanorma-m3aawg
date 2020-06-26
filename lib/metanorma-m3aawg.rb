require "asciidoctor" unless defined? Asciidoctor::Converter
require_relative "asciidoctor/m3aawg/converter"
require_relative "isodoc/m3aawg/html_convert"
require_relative "isodoc/m3aawg/word_convert"
require_relative "isodoc/m3aawg/pdf_convert"
require_relative "isodoc/m3aawg/presentation_xml_convert"
require_relative "metanorma/m3aawg/version"

if defined? Metanorma
  require_relative "metanorma/m3aawg"
  Metanorma::Registry.instance.register(Metanorma::M3AAWG::Processor)
end
