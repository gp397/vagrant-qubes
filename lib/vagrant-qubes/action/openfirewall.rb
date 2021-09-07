require 'log4r'
require 'open3'
require 'socket'

module VagrantPlugins
  module Qubes
    module Action
      class OpenFirewall
        def initialize(app, _env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_qubes::action::openfirewall')
        end

        def call(env)
          openfirewall(env)
          @app.call(env)
        end

        def openfirewall(env)
          @logger.info('vagrant-qubes, openfirewall: start...')

          # Get config
          machine = env[:machine]
          config = env[:machine].provider_config

          if env[:machine_state].to_s == 'running'
            vagrant_ip = Socket.ip_address_list.find {|a| a.ipv4? ? !(a.ipv4_loopback?) : !(a.ipv6_loopback?) }

            env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
              message: 'vagrant ip ' + vagrant_ip.ip_address.to_s)

            command = 'echo "' + vagrant_ip.ip_address.to_s\
              + '" | qrexec-client-vm dom0 vagrant_openfw+' + env[:machine].config.vm.hostname

            stdout, stderr, status = Open3.capture3(command)
            if status != 0
              raise Errors::QRExecError,
                    message: 'qrexec failed with status' + status.to_s
            end
          else
            raise Errors::GeneralError,
            message: 'VM not running so cannot edit firewall policy'
          end
        end
      end
    end
  end
end
