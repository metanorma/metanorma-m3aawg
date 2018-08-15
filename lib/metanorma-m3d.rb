require "asciidoctor" unless defined? Asciidoctor::Converter
require_relative "asciidoctor/m3d/converter"
require_relative "isodoc/m3d/m3dhtmlconvert"
require_relative "isodoc/m3d/m3dwordconvert"
require_relative "asciidoctor/m3d/version"

if defined? Metanorma
  require_relative "metanorma/m3d"
  Metanorma::Registry.instance.register(Metanorma::M3d::Processor)
end
