def run_sane_defaults args
  pause_when_unfocused args
end

# from the docs
def pause_when_unfocused args
  # if the keyboard doesn't have focus, and the game is in production mode, and it isn't the first tick
  if (!args.inputs.keyboard.has_focus &&
      args.gtk.production &&
      Kernel.tick_count != 0)
    args.outputs.background_color = [0, 0, 0]
    args.outputs.labels << { x: 640,
                             y: 360,
                             text: "Game Paused (click to resume).",
                             alignment_enum: 1,
                             r: 255, g: 255, b: 255 }
    # consider setting all audio volume to 0.0
  #else
    # perform your regular tick function
  end
end
