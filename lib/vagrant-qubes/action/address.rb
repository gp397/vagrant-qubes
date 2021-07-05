require 'log4r'

module VagrantPlugins
  module Qubes
    module Action
      class Address
        def initialize(app, _env, multi)
          @app = app
          @logger = Log4r::Logger.new('vagrant_qubes::action::address')
          @multi = multi
        end
  
        def call(env)
          address(env)
          @app.call(env)
        end
  
        def address(env)
          @logger.info('vagrant-qubes, address: start...')

          # Get config.
          machine = env[:machine]
          config = env[:machine].provider_config

          # return nil if machine is down.
          return nil if machine.state.id != :running

          ssh_info = machine.ssh_info
          return nil if !ssh_info

          if @multi == true
            env[:ui].info ssh_info[:host]
          else
            env[:ui].info ssh_info[:host]
          end
        end
      end
    end
  end
end