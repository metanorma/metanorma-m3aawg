# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module M3aawg
    # m3aawg's lutaml-model register: type substitutions from standoc.
    # Formerly Metanorma::Registers::Setup.setup_m3d_register in metanorma-document.
    module Registers
      module_function

      def setup
          reg = Lutaml::Model::Register.new(:m3d_document)
          Lutaml::Model::GlobalRegister.register(reg)
      end
    end
  end
end
