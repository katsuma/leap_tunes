# coding: utf-8
require 'leap-motion-ws'
require 'leap_tunes/itunes_controller'
require 'leap_tunes/version'
require 'itunes-client'
require 'growl'

module LeapTunes
  def start
    controller = ItunesController.new

    Signal.trap('TERM') { controller.stop }
    Signal.trap('KILL') { controller.stop }
    Signal.trap('INT')  { controller.stop }

    controller.start
  end

  module_function :start
end
