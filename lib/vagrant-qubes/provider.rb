require 'log4r'
require 'vagrant'

module VagrantPlugins
  module Qubes
    # Provider class
    class Provider < Vagrant.plugin('2', :provider)
      # @param [Boolean] raise_error If true, raise exception if not usable.
      # @return [Boolean]
      def self.usable?(raise_error=false)
        # Return true by default for backwards compat since this was
        # introduced long after providers were being written.
        true
      end

      # If Environment.can_install_provider? returns false, then an error
      # will be shown to the user.
      def self.installed?
        # By default return true for backwards compat so all providers
        # continue to work.
        true
      end

      # @param [Vagrant::Machine] machine The machine that this provider
      # is responsible for.
      def initialize(machine)
        @machine = machine
        @logger = Log4r::Logger.new('vagrant_qubes::action::provider')
      end

      # @param [Symbol] name Name of the action.
      # @return [Object] A callable action sequence object, whether it
      #   is a proc, object, etc.
      def action(name)
        method = "action_#{name}"
        if Action.respond_to? method
          Action.send(method)
        else
          # the specified action is not supported
          nil
        end
      end

      # This method is called if the underlying machine ID changes. Providers
      # can use this method to load in new data for the actual backing
      # machine or to realize that the machine is now gone (the ID can
      # become `nil`). No parameters are given, since the underlying machine
      # is simply the machine instance given to this object. And no
      # return value is necessary.
      def machine_id_changed
      end

      # This should return a hash of information that explains how to
      # SSH into the machine. If the machine is not at a point where
      # SSH is even possible, then `nil` should be returned.
      #
      # The general structure of this returned hash should be the
      # following:
      #
      #     {
      #       host: "1.2.3.4",
      #       port: "22",
      #       username: "mitchellh",
      #       private_key_path: "/path/to/my/key"
      #     }
      #
      # **Note:** Vagrant only supports private key based authentication,
      # mainly for the reason that there is no easy way to exec into an
      # `ssh` prompt with a password, whereas we can pass a private key
      # via commandline.
      #
      # @return [Hash] SSH information. For the structure of this hash
      #   read the accompanying documentation for this method.
      def ssh_info
        env = @machine.action('read_ssh_info')
        env[:machine_ssh_info]
      end

      # This should return the state of the machine within this provider.
      # The state must be an instance of {MachineState}. Please read the
      # documentation of that class for more information.
      #
      # @return [MachineState]
      def state
        env = @machine.action('read_state')
        state_id = env[:machine_state]

        @logger.info("vagrant-qubes, boot: state_id: #{env[:state_id]}")

        short = I18n.t("vagrant_qubes.states.#{state_id}.short")
        long  = I18n.t("vagrant_qubes.states.#{state_id}.long")

        # If we're not created, then specify the special ID flag
        if state_id == :not_created
          state_id = Vagrant::MachineState::NOT_CREATED_ID
        end

        # Return the MachineState object
        Vagrant::MachineState.new(state_id, short, long)
      end
    end
  end
end