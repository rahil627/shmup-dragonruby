def run_sane_defaults args
  pause_when_unfocused args
end

# from the docs
def pause_when_unfocused args
  # if the keyboard doesn't have focus, and the game is in production mode, and it isn't the first tick
  if (!args.inputs.keyboard.has_focus && Kernel.tick_count != 0) # && args.gtk.production 
    args.outputs.background_color = [0, 0, 0]
    args.outputs.labels << { x: 640,
                             y: 360,
                             text: "PAWS",
                             alignment_enum: 1,
                             r: 255, g: 255, b: 255 }
     $args.state.paused ||= true # could also return it, but the call stack is already 3 levels deep :/
    # consider setting all audio volume to 0.0
  else
    # perform your regular tick function
     $args.state.paused ||= false
  end
end
