require "asciidoctor" unless defined? Asciidoctor::Converter
require_relative "asciidoctor/m3d/converter"
require_relative "isodoc/m3d/html_convert"
require_relative "isodoc/m3d/pdf_convert"
require_relative "isodoc/m3d/word_convert"
require_relative "metanorma/m3d/version"

if defined? Metanorma
  require_relative "metanorma/m3d"
  Metanorma::Registry.instance.register(Metanorma::M3d::Processor)
end
