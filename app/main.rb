
require "app/sane_defaults"
require "app/handle_input"

# args.state.c = constants

# @params args [GTK::Args]
# main game loop
def tick args
  run_default_app args # TEMP
  
  init_once args
  run_sane_defaults args
  handle_input args # TODO: module vs file?
  handle_logic args
  take_out_the_trash args
  handle_output args
end

def init_once args

  # TODO: should only do once

  # TODO: surely somehwre..
  # args.state.screen ||= {x: 0, y: 0, h: 720, w: 1280}

  # NOTE: because this is run every tick, use ||=
  args.state.player ||= {x: 600, y: 320, w: 80, h: 80, path: 'sprites/circle/violet.png', vx: 0, vy: 0, health: 10, cooldown: 0, score: 0}

  args.state.player[:r] = args.state.player[:g] = args.state.player[:b] = (args.state.player[:health] * 25.5).clamp(0, 255)

  # TODO: args.state.players ||= []
  args.state.lasers ||= []
  end

def handle_output args
    args.outputs.background_color = [128, 0, 128]
  # output at the end
    args.outputs.sprites << [args.state.player, args.state.enemies, args.state.lasers ] # args.state.lasers.head 

  args.state.clear! if args.state.player[:health] < 0 # Reset the game if the player's health drops below zero
end

def handle_logic args
  # TODO: loop through each entity vs seperate loops by logic: move, collision, etc.
  # def should seperate by logic..
  loop_lasers args
end

# TODO: surely exists somewhere..
def loop_lasers args
  args.state.lasers.each do |l|

    s = args.state.c.laser_speed ||= 1 # speed, 1/720 per tick..?

    # extend
    l.h += s 

    # calculate from angle and length
    # distance = l.h
    # x = l.x + distance * (Math.cos l.angle.to_radians)
    # y = l.y + distance * (Math.sin l.angle.to_radians)

    # just create a point/sprite and update every frame instead
    vx = l.dx * s
    vy = l.dy * s
    l.head.x += vx
    l.head.y += vy

    # when laser.head hits a wall, reflect
    if off_screen_or_on_the_edge? l.head
      l.trash ||= true
      
      # add a reflecting laser
      
      # reflect
      l.angle = reflect_angle l.angle
      # TODO: flip dx, dy, probably depends on the angle or axis hit..?
      dx = l.dx * -1
      dy = l.dy * -1
      
      make_laser args, {x: l.head.x, y: l.head.y, dx: dx, dy: dy}
    end

  end
end

def reflect_angle angle
  180 - angle
end

  
# "For what it’s worth, you could implement this behavior yourself — instead of calling “delete”, you could set obj.garbage = true. After your iteration, then you only need array.reject!(&:garbage) to clean up." - pvande
def take_out_the_trash args
  args.state.lasers.reject!(&:trash) # TODO: learn &:key
end

def off_screen_or_on_the_edge? e
  # if not Geometry.inside_rect?(l.rect, args.state.screen)
  e.x <= 0 - e.w || e.y <= 0 - e.h || e.x >= 1280 + e.w || e.y >= 720 + e.h
end

def off_screen? e
  # if not Geometry.inside_rect?(l.rect, args.state.screen)
  e.x < 0 - e.w || e.y < 0 - e.h || e.x > 1280 + e.w || e.y > 720 + e.h
end










# temp

def run_default_app args
  args.state.logo_rect ||= { x: 576,
                             y: 200,
                             w: 128,
                             h: 101 }

  args.outputs.labels  << { x: 640,
                            y: 510,
                            text: "Documentation is located under the ./docs/docs.txt directory. 150+ samples are located under the ./samples directory.",
                            size_px: 20,
                            anchor_x: 0.5,
                            anchor_y: 0.5 }

end


  
