require 'log4r'
require 'open3'

module VagrantPlugins
  module Qubes
    module Action
      class ReadSSHInfo
        def initialize(app, _env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_qubes::action::read_ssh_info')
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env)
          @app.call(env)
        end

        def read_ssh_info(env)
          @logger.info('vagrant-qubes, read_ssh_info: start...')

          # Get config.
          machine = env[:machine]
          config = env[:machine].provider_config

          # return nil if machine.id.nil?

          #  most of the time, state will be nil.   But that's OK, we need to
          #  continue to read_ssh_info...
          if (env[:machine_state].to_s == 'not_created' ||
            env[:machine_state].to_s == 'halted' )
            config.saved_ipaddress = nil
            return nil
          end

          @logger.info("vagrant-qubes, read_ssh_info: machine id: #{machine.id}")
          @logger.info('vagrant-qubes, read_ssh_info: current state:'\
                       " #{env[:machine_state]}")

          if config.saved_ipaddress.nil? or config.local_use_ip_cache == 'False'
            # Figure out vm_ipaddress

            command = 'qrexec-client-vm dom0 vagrant_list+' + env[:machine].config.vm.hostname
            stdout, stderr, status = Open3.capture3(command)

            fields = stdout.split('|')
            ipaddress = fields.at(3).to_s

#            env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
#              message: 'address ' + ipaddress)

            return nil if (ipaddress == '')

            config.saved_ipaddress = ipaddress

            return {
              host: ipaddress,
              port: 22
            }
          else
            env[:ui].info "Using cached guest IP address"
            ipaddress = config.saved_ipaddress

            return {
              host: ipaddress,
              port: 22
            }
          end
        end
      end
    end
  end
end
