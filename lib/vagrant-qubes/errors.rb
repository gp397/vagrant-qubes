require 'vagrant'

module VagrantPlugins
  module Qubes
    module Errors
      class QubesErrors < Vagrant::Errors::VagrantError
        error_namespace('vagrant_qubes.errors')
      end

      class QRExecError < QubesErrors
        error_key(:qrexec_error)
      end

      class GeneralError < QubesErrors
        error_key(:general_error)
      end
    end
  end
end
  