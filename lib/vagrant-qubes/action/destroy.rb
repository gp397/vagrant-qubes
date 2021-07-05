require 'log4r'
require 'open3'

module VagrantPlugins
  module Qubes
    module Action
      class Destroy
        def initialize(app, _env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_qubes::action::destroy')
        end

        def call(env)
          destroy(env)
          @app.call(env)
        end

        def destroy(env)
          @logger.info('vagrant-qubes, destroy: start...')

          # Get config
          machine = env[:machine]
          config = env[:machine].provider_config

          @logger.info("vagrant-qubes, destroy: machine id: #{machine.id}")
          @logger.info('vagrant-qubes, destroy: current state: '\
                       "#{env[:machine_state]}")

          if env[:machine_state].to_s == 'not_created'
            env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
              message: 'Cannot destroy in state ' + env[:machine_state].to_s)
          elsif env[:machine_state].to_s != 'halted'
            raise Errors::GeneralError,
            message: 'VM should have been halted before destroy'
          else
            command = 'qrexec-client-vm dom0 vagrant_destroy+' + env[:machine].config.vm.hostname
            stdout, stderr, status = Open3.capture3(command)
            if status != 0
              raise Errors::QRExecError,
                    message: 'qrexec failed with status' + status.to_s
            end
            env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
              message: env[:machine].config.vm.hostname + ' Removed')
          end
        end
      end
    end
  end
end
