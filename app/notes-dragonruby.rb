
# LSP
$args. not args.
  # triggers auto-complete
  # **all of DR's functions are here**

$args.gtk.
GTK.
  # this also works, but then you'd have to remember the name of the classes

args.state.player[:
  # triggers auto-complete
  # shows all keys for the current hash, then arts.inputs, then args.outputs

# @params args [GTK::Args] # this tells solargraph a type hint
def tick args
  args.
    # triggers auto-complete
    # but at the moment, it only works within the function, and doesn't propogate the call stack
end
  
  

player[:x] = player[:x].add(dx).clamp(0)
  # "In DR specifically, Hashes have access semantics that look more like JavaScript objects: you can access (Symbol) keys either with square brackets or dot-notation. The rationale for this is that it makes the code change smaller when migrating from Hashes to Objects, with the bonus that dot-notation can actually be faster than the equivalent bracketed lookup." - pvande


args.state
  # global state
  # use console to see what's inside interactively
    # type 'args', then press tab
      # same for gtk
      
args.outputs.debug
  # output debug stuff here, probably doesn't go to production release

# better to render via sprites instead of drawing api
  # - solids, borders, lines are debug objects and not meant for production, as they are drawn one pixel at a time..! lines can be used, but a sprite is still much better

# amir's response about dynamic typing
The way DR mitigates the lack of a static typing "feedback" is:
hotloading with game state being retained
built-in HUD/Quake Console
args.outputs.watch https://docs.dragonruby.org/#/api/outputs?id=watch
game play recording and replay https://docs.dragonruby.org/#/api/runtime?id=start_recording YouTube demo.d

the (very real) benefits of dynamic typing:
you are never waiting to start working again
when in the prototyping phase, where you don't know what you're building yet, there's nothing asking you "but what are you building?!"
in the event of an exception, the game is paused giving you a chance to introspect your game state
extreme flexibilty, in a domain - game/artistic endeavors - where things simply don't fit into nice neat boxes
significantly less code is written to accomplish the same task, hands down ^_^

# secrets that can't be found via lsp
rand # global var?

sprite = { path: :pixel }
  # generates a pixel image

{x: 0, y: 0, w: 10, h: 10}.top/bottom/left/right
  # returns the length of a single side

1.to_radians/degrees

