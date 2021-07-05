require 'pathname'
require 'vagrant-qubes/plugin'

module VagrantPlugins
  module Qubes
    lib_path = Pathname.new(File.expand_path('../vagrant-qubes', __FILE__))
    autoload :Action, lib_path.join('action')
    autoload :Errors, lib_path.join('errors')

    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end
