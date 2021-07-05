require 'log4r'
require 'timeout'

module VagrantPlugins
  module Qubes
    module Action
      class WaitForState
        # env[:result] will be false in case of timeout.
        # @param [Symbol] state Target machine state.
        # @param [Number] timeout Timeout in seconds.
        def initialize(app, _env, state, timeout)
          @app     = app
          @logger  = Log4r::Logger.new('vagrant_qubes::action::wait_for_state')
          @state   = state
          @timeout = timeout
        end

        def call(env)
          env[:result] = 'True'
          if env[:machine].state.id != @state
            env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
                                 message: "Waiting for state \"#{@state}\"")
            begin
              Timeout.timeout(@timeout) do
                until env[:machine].state.id == @state
                  sleep 4
                end
                env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
                                     message: "Success, state is now \"#{@state}\"")
              end

            rescue Timeout::Error
              env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
                                   message: "Timeout waiting for \"#{@state}\"")
              env[:result] = 'False' # couldn't reach state in time
            end
          else
            env[:ui].info I18n.t('vagrant_qubes.vagrant_qubes_message',
              message: "Success, state is now \"#{@state}\"")
          end
          env[:machine].provider_config.saved_ipaddress = nil
          @app.call(env)
        end
      end
    end
  end
end