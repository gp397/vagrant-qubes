require 'log4r'
require 'open3'

module VagrantPlugins
  module Qubes
    module Action
      class CreateVM
        def initialize(app, _env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_qubes::action::createvm')
        end

        def call(env)
          createvm(env)
          @app.call(env)
        end

        def createvm(env)
          @logger.info('vagrant-qubes, createvm: start...')

          # Get config
          machine = env[:machine]
          config = env[:machine].provider_config

          if env[:machine_state].to_s == 'not_created'
            env[:ui].info I18n.t('vagrant_qubes.vmbuild_not_done')
          else
            env[:ui].info I18n.t('vagrant_qubes.vmbuild_already_done')
            return
          end

          # Do some config validation
          if env[:machine].config.vm.hostname.nil?
            raise Errors::GeneralError,
                  message: 'Hostname is not set, fix Vagrantfile'
            return
          end

          if config.guest_type.is_a? String
            case config.guest_type
            when 'AppVM'
              command = 'echo "' + config.guest_type\
                + ' ' + config.guest_label\
                + ' ' + config.guest_template\
                + ' ' + config.guest_numvcpus.to_s\
                + ' ' + config.guest_memsize.to_s\
                + ' ' + config.guest_netvm\
                + '" | qrexec-client-vm dom0 vagrant_create+' + env[:machine].config.vm.hostname
              stdout, stderr, status = Open3.capture3(command)
              if status != 0
                raise Errors::QRExecError,
                      message: 'qrexec failed with status' + status.to_s
              end
            else
              raise Errors::GeneralError,
                    message: 'guest type ' + config.guest_type + ' is not supported'
              return
            end
          else
            raise Errors::GeneralError,
                  message: 'Type is not a string, fix Vagrantfile'
            return
          end
        end
      end
    end
  end
end