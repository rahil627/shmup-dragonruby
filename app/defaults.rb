
# common sane defaults accross
module Defaults

# def run_defaults
#   pause_when_unfocused
# end

# run on tick
# won't run on first frame, in case of init
# returns true/false
def pause_because_unfocused?
  # from the docs
  if unfocused?
    # good for programming hot-reload workflow
      # saves battery too!
    args.outputs.background_color = [0, 0, 0, 125] # alpha doesn't work here because there is no other ouput, the program stops after this..!
    # TODO: a transaparent pause over the last ouput, not so simple..
    args.outputs.labels << { x: 640,
                           y: 360,
                           text: "PAWS",
                           alignment_enum: 1,
                           r: 255, g: 255, b: 255 }
    # $args.state.paused ||= true # could also return it, but the call stack is already 3 levels deep :/
    true
    # consider setting all audio volume to 0.0
  else
    # perform your regular tick function
    # $args.state.paused ||= false
    false
  end
end

def unfocused?
  # TODO: only good for desktop, platform conditionals?
  # just return on production release for now
  return if args.gtk.production

  # if the keyboard doesn't have focus, and the game is in production mode, and it isn't the first tick
  (not args.inputs.keyboard.has_focus and Kernel.tick_count != 0)
end


end # module

