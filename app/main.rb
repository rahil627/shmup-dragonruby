
require "app/sane_defaults"
require "app/handle_input"

# main game loop
# @param args [GTK::Args]
def tick args
  run_default_app args # TEMP
  
  run_sane_defaults args
  # return if args.state.paused # comment this out to remove pause, and instead can use the console to pause it TODO: breaks the game.. :/
  init_once args
  handle_input args # TODO: module vs file?
    # move
    # shoot
  handle_logic args
  take_out_the_trash args
  handle_output args # vs render
end

def init_once args

  # just note some state data here
  # args.state.c = constants

  # TODO: should only do once

  # TODO: surely somehwre..
  # args.state.screen ||= {x: 0, y: 0, h: 720, w: 1280}

  # NOTE: because this is run every tick, use ||=
  args.state.player ||= {x: 600, y: 320, w: 80, h: 80, path: 'sprites/circle/violet.png', vx: 0, vy: 0, trash: false, health: 10, cooldown: 0, score: 0}

  args.state.player[:r] = args.state.player[:g] = args.state.player[:b] = (args.state.player[:health] * 25.5).clamp(0, 255)

  # TODO: args.state.players ||= []
  args.state.lasers ||= [] # TODO: not {}??
  end

def handle_output args
    args.outputs.background_color = [128, 0, 128]
  # output at the end
    args.outputs.sprites << [args.state.player, args.state.enemies, args.state.lasers ] # TODO: args.state.lasers.head 

  args.state.clear! if args.state.player[:health] < 0 # Reset the game if the player's health drops below zero
end

def handle_logic args
  # store_inputs
  # move_players
  # shoot_players
  handle_lasers args
    # extend
    # reflect
      # add new laser
    # TODO:
  # check_laser_collisions args
    # do after reflect and shoot_players, 'cause they add new lasers
end

def check_laser_collisions args
  # TODO: incomplete
  args.state.lasers.each do |l| # loop players or lasers?
    # args.state.enemies.reject! do |enemy| # TODO: reject, but no conditional..?
    # args.state.player_bullets.any? do |bullet| # TODO: LEARN: any, no conditional
    # TODO: should center sprite anchors, especially player
      # Check if enemy and player are within 20 pixels of each other (i.e. overlapping)
    if 1000 > (l.x - args.state.player.x) ** 2 + (l.y - args.state.player.y) ** 2
      # l.trash ||= true
        # nahhh, keep laser
      # kill player
      args.state.player.trash ||= true
    end
  end
end


# TODO: surely exists somewhere..
def handle_lasers args
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
      # angle vs vector impl
      # l.angle = reflect_angle l.angle

      # vector is easier to handle here..
      dx = l.dx
      dy = l.dy
      if off_screen_or_on_the_edge_left_right? l.head
        dx *= -1
      else #if off_screen_or_on_the_edge_top_bottom? l
        dy *= -1
      end
      
      make_laser args, {x: l.head.x, y: l.head.y, dx: dx, dy: dy}
    end

  end
end

# def reflect_angle angle
#   180 - angle
# end
  
# "For what it’s worth, you could implement this behavior yourself — instead of calling “delete”, you could set obj.garbage = true. After your iteration, then you only need array.reject!(&:garbage) to clean up." - pvande
def take_out_the_trash args
  args.state.lasers.reject!(&:trash) # TODO: learn &:key
  # args.state.players.reject!(&:trash) # TODO: learn &:key
  # args.state.player = nil # will crash on output
end

def off_screen_or_on_the_edge_top_bottom? e
  e.y <= 0 - e.h || e.y >= 720 + e.h
end

def off_screen_or_on_the_edge_left_right? e
  e.x <= 0 - e.w || e.x >= 1280 + e.w
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


  
