#  Config

module VagrantPlugins
  module Qubes
    # Config class
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :debug
      attr_accessor :guest_type
      attr_accessor :guest_label
      attr_accessor :guest_template
      attr_accessor :guest_numvcpus
      attr_accessor :guest_memsize
      attr_accessor :guest_netvm
      attr_accessor :saved_ipaddress

      def initialize
        @debug = 'False'
        @local_use_ip_cache = 'True'
        @saved_ipaddress = nil
      end

      def finalize!
        if @local_use_ip_cache =~ /false/i
          @local_use_ip_cache = 'False'
        else
          @local_use_ip_cache = 'True'
        end
        @saved_ipaddress = nil
      end
    end
  end
end
