# coding: utf-8
module LeapTunes
  class ItunesController < LEAP::Motion::WS

    FRAME_CHECK_INTERVAL_SEC = 2

    VALID_HAND_SIZE = 1
    RESET_HAND_SIZE = 0

    PLAY_PAUSE_POINTABLE_SIZES = (4..5)
    PLAY_NEXT_POINTABLE_SIZES = (1..2)

    def initialize
      @prev_time = 0.0
      @playing = Itunes::Player.playing?
      @player_controlled = true
    end

    def play_next_track
      track = Itunes::Player.next_track
      Growl.notify track.artist, title: track.name, icon: 'Itunes'
      puts "Play next track, \"#{track.name} by #{track.artist}\""
      @playing = true
    end

    def play_pause
      if @playing
        Itunes::Player.pause
        puts 'Pause current track'
      else
        Itunes::Player.play
        track = Itunes::Player.current_track
        Growl.notify track.artist, title: track.name, icon: 'Itunes'
        puts "Play the current track, \"#{track.name} by #{track.artist}\""
      end

      @playing = !@playing
    end

    def on_frame(frame)
      return unless frame.timestamp

      prev_time = @prev_time
      current_time = Time.now.to_i
      time_diff = current_time - prev_time
      pointables_size = frame.pointables.size
      hands_size = frame.hands.size

      if hands_size == VALID_HAND_SIZE && @player_controlled
        return if frame.hands.size != VALID_HAND_SIZE
        return if time_diff < FRAME_CHECK_INTERVAL_SEC

        case pointables_size
        when PLAY_NEXT_POINTABLE_SIZES then play_next_track
        when PLAY_PAUSE_POINTABLE_SIZES then play_pause
        end

        @prev_time = current_time
        @player_controlled = false

      elsif hands_size == RESET_HAND_SIZE
        @player_controlled = true
      end

    end
  end
end
