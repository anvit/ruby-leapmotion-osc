require 'leap-motion-ws'
require 'ruby-osc'
require 'rubygems'

include OSC

class LeapTest < LEAP::Motion::WS
  def on_connect
    puts "Connect"
  end

  def on_frame frame
    OSC.run do
      client = Client.new 9090
      if frame.hands.size > 0
        if frame.hands.size == 2
        	if frame.hands[0].stabilizedPalmPosition[0] < frame.hands[1].stabilizedPalmPosition[0]
        		rot = ((Math.atan2(frame.hands[0].palmNormal[0], -frame.hands[0].palmNormal[1]) * 180) / Math::PI)
            	client.send Message.new("/leap/h/l/r", rot)
            	client.send Message.new("/leap/h/l/x", frame.hands[0].stabilizedPalmPosition[0])
            	client.send Message.new("/leap/h/l/y", frame.hands[0].stabilizedPalmPosition[1])
            	client.send Message.new("/leap/h/l/z", frame.hands[0].stabilizedPalmPosition[2])
            	rot = ((Math.atan2(frame.hands[1].palmNormal[0], -frame.hands[1].palmNormal[1]) * 180) / Math::PI)
            	client.send Message.new("/leap/h/r/r", rot)
            	client.send Message.new("/leap/h/r/x", frame.hands[1].stabilizedPalmPosition[0])
            	client.send Message.new("/leap/h/r/y", frame.hands[1].stabilizedPalmPosition[1])
            	client.send Message.new("/leap/h/r/z", frame.hands[1].stabilizedPalmPosition[2])
        	else
        		rot = ((Math.atan2(frame.hands[0].palmNormal[0], -frame.hands[0].palmNormal[1]) * 180) / Math::PI)
            	client.send Message.new("/leap/h/r/r", rot)
            	client.send Message.new("/leap/h/r/x", frame.hands[0].stabilizedPalmPosition[0])
            	client.send Message.new("/leap/h/r/y", frame.hands[0].stabilizedPalmPosition[1])
            	client.send Message.new("/leap/h/r/z", frame.hands[0].stabilizedPalmPosition[2])
            	rot = ((Math.atan2(frame.hands[1].palmNormal[0], -frame.hands[1].palmNormal[1]) * 180) / Math::PI)
            	client.send Message.new("/leap/h/l/r", rot)
            	client.send Message.new("/leap/h/l/x", frame.hands[1].stabilizedPalmPosition[0])
            	client.send Message.new("/leap/h/l/y", frame.hands[1].stabilizedPalmPosition[1])
            	client.send Message.new("/leap/h/l/z", frame.hands[1].stabilizedPalmPosition[2])
        	end
        else
          frame.hands.each do |dat|
            rot = ((Math.atan2(dat.palmNormal[0], -dat.palmNormal[1]) * 180) / Math::PI)
            client.send Message.new("/leap/h/m/r", rot)
            client.send Message.new("/leap/h/m/x", dat.stabilizedPalmPosition[0])
            client.send Message.new("/leap/h/m/y", dat.stabilizedPalmPosition[1])
            client.send Message.new("/leap/h/m/z", dat.stabilizedPalmPosition[2])
            # puts "#{dat.stabilizedPalmPosition[0]}"
          end
        end
      end
    end
  end

  def on_disconnect
    puts "disconect"
    stop
  end
end

leap = LeapTest.new(:enable_gesture => true)

Signal.trap("TERM") do
  puts "Terminating..."
  leap.stop
end
Signal.trap("KILL") do
  puts "Terminating..."
  leap.stop
end
Signal.trap("INT") do
  puts "Terminating..."
  leap.stop
end

leap.start