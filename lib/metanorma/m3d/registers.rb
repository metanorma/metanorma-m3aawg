# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module M3d
    # M3D's lutaml-model register: creates the :m3d_document context.
    # Formerly Metanorma::Registers::Setup.setup_m3d_register in
    # metanorma-document; M3D adds no substitutions over the standoc
    # sections.
    module Registers
      module_function

      def setup
        reg = Lutaml::Model::Register.new(:m3d_document)
        Lutaml::Model::GlobalRegister.register(reg)
      end
    end
  end
end
