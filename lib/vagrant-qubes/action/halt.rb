require 'log4r'
require 'open3'

module VagrantPlugins
  module Qubes
    module Action
      class Halt
        def initialize(app, _env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_qubes::action::halt')
        end

        def call(env)
          halt(env)
          @app.call(env)
        end

        def halt(env)
          @logger.info('vagrant-qubes, halt: start...')

          # Get config
          machine = env[:machine]
          config = env[:machine].provider_config

          @logger.info("vagrant-qubes, halt: machine id: #{machine.id}")
          @logger.info('vagrant-qubes, halt: current state: '\
                       "#{env[:machine_state]}")

          if env[:machine_state].to_s == 'halted'
            env[:ui].info I18n.t('vagrant_qubes.already_halted')
          elsif env[:machine_state].to_s == 'not_created'
            env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
              message: 'Cannot halt in state ' + env[:machine_state].to_s)
          else
            command = 'qrexec-client-vm dom0 vagrant_stop+' + env[:machine].config.vm.hostname
            stdout, stderr, status = Open3.capture3(command)
            if status != 0
              raise Errors::QRExecError,
                    message: 'qrexec failed with status' + status.to_s
            end
            env[:ui].info I18n.t('vagrant_qubes.states.halted.long')
          end
        end
      end
    end
  end
end
