require 'log4r'
require 'open3'

module VagrantPlugins
  module Qubes
    module Action
      class ReadState
        def initialize(app, _env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_qubes::action::read_state')
        end

        def call(env)
          env[:machine_state] = read_state(env)
          @app.call(env)
        end

        def read_state(env)
          @logger.info('vagrant-qubes, read_state: start...')

          # Get config.
          machine = env[:machine]
          config = env[:machine].provider_config

          #return :not_created if machine.id.to_i < 1

          state = ''

          command = 'qrexec-client-vm dom0 vagrant_list+' + env[:machine].config.vm.hostname
#          env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
#            message: command)
          stdout, stderr, status = Open3.capture3(command)
          stdout.each_line do |line|
            fields = line.split('|')
            state = fields.at(1)
#            env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
#              message: 'state ' + state)
          end

          case state
          when 'Running'
            return :running
          when 'Halted'
            return :halted
          when 'Transient'
            return :transient
          else        
            return :not_created
          end
        end
      end
    end
  end
end