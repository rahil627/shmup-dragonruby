
require "app/sane_defaults"
require "app/handle_input"

# main game loop
# args is a magical object that includes everything?
def tick args

  # app defaults
  run_sane_defaults args # ruby TODO: syntax highlighting for function without () not working

  run_default_app args

  handle_input args
  handle_output args

# TODO: https://discord.dragonruby.org'

end

def init args
  args.state.player         ||= {x: 600, y: 320, w: 80, h: 80, path: 'sprites/circle/violet.png', vx: 0, vy: 0, health: 10, cooldown: 0, score: 0}

  args.state.player[:r] = args.state.player[:g] = args.state.player[:b] = (args.state.player[:health] * 25.5).clamp(0, 255)
end

def handle_output args
  # output at the end
  args.outputs.sprites << [args.state.player, args.state.enemies, args.state.player_bullets]
  args.state.clear! if args.state.player[:health] < 0 # Reset the game if the player's health drops below zero
end




# temp

def run_default_app args
# to NOTE: if not initalized, assign
  # " It's a nice way to embed your initialization code right next to where you need the variable."
  args.state.logo_rect ||= { x: 576,
                             y: 200,
                             w: 128,
                             h: 101 }

  # << appends array to the args object
  # NOTE: "DragonRuby clears out these arrays every frame"
  args.outputs.labels  << { x: 640,
                            y: 600,
                            text: 'Hello World!',
                            size_px: 30,
                            anchor_x: 0.5,
                            anchor_y: 0.5 }

  args.outputs.labels  << { x: 640,
                            y: 510,
                            text: "Documentation is located under the ./docs/docs.txt directory. 150+ samples are located under the ./samples directory.",
                            size_px: 20,
                            anchor_x: 0.5,
                            anchor_y: 0.5 }

  args.outputs.labels  << { x: 640,
                            y: 480,
                            text: "If you prefer formatted docs, you can access them locally at http://localhost:9001 or online at http://docs.dragonruby.org.",
                            size_px: 20,
                            anchor_x: 0.5,
                            anchor_y: 0.5 }

  args.outputs.labels  << { x: 640,
                            y: 400,
                            text: "The code that powers what you're seeing right now is located at ./mygame/app/main.rb.",
                            size_px: 20,
                            anchor_x: 0.5,
                            anchor_y: 0.5 }

end







