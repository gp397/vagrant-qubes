require 'vagrant/action/builder'

module VagrantPlugins
  module Qubes
    # actions and how to run them
    module Action
      include Vagrant::Action::Builtin

      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ReadState
        end
      end

      def self.action_address
        Vagrant::Action::Builder.new.tap do |b|
          b.use Address, false
        end
      end

      def self.action_address_multi
        Vagrant::Action::Builder.new.tap do |b|
          b.use Address, true
        end
      end

      def self.action_read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ReadSSHInfo
        end
      end

      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          # b.use HandleBox - This downloads the "box"
          b.use ReadState
          b.use CreateVM
          b.use ReadState
          b.use Boot
          b.use Call, WaitForState, :running, 240 do |env1, b1|
            if env1[:result] == 'True'
              b1.use action_provision
            end
          end
        end
      end

      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ReadState
          b.use Call, WaitForState, :running, 240 do |env1, b1|
            if env1[:result] == 'True'
              b1.use ReadState
              #b1.use Provision
              #b1.use SyncedFolderCleanup
              #b1.use SyncedFolders
              #b1.use SetHostname
            end
          end
        end
      end

      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, ReadState do |env1, b1|
            b1.use Halt unless env1[:machine_state] == 'halted'
            b1.use ReadState
            b1.use Call, WaitForState, :halted, 240 do |env2, b2|
              if env2[:result] == 'True'
                b2.use Destroy
              end
            end
          end
        end
      end

      action_root = Pathname.new(File.expand_path('../action', __FILE__))
      autoload :Boot, action_root.join('boot')
      autoload :CreateVM, action_root.join('createvm')
      autoload :ReadState, action_root.join('read_state')
      autoload :WaitForState, action_root.join('wait_for_state')
      autoload :Address, action_root.join('address')
      autoload :ReadSSHInfo, action_root.join('read_ssh_info')
      autoload :Halt, action_root.join('halt')
      autoload :Destroy, action_root.join('destroy')
    end
  end
end
      