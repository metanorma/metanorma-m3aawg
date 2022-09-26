require "metanorma"
require "metanorma-generic"
require "metanorma/m3aawg/processor"

module Metanorma
  module M3AAWG

    class Configuration < Metanorma::Generic::Configuration
    end

    class << self
      extend Forwardable

      attr_accessor :configuration

      Configuration::CONFIG_ATTRS.each do |attr_name|
        def_delegator :@configuration, attr_name
      end

      def configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end
    end

    configure {}
  end
end
Metanorma::Registry.instance.register(Metanorma::M3AAWG::Processor)

