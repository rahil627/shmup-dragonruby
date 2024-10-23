
require_relative "defaults"
require_relative "input"

def tick args
  $game ||= Game.new
  $game.args = args # for attr_gtk macro
  $game.tick
end


class Game
attr_gtk

include Input
include Defaults # plural?

# main game loop
# @param args [GTK::Args]
def tick
  # run_defaults # from defaults module
  init if Kernel.tick_count.zero? # thanks to pvande
  return if pause_because_unfocused? # from defaults module
  handle_input # from input module
    # move_player
    # shoot_player
  handle_logic
  take_out_the_trash
  handle_output # vs render
end

def reset
  init
end

def init
  puts "init"
  
  # just note some state data here
  # args.state.c = constants

  # TODO: surely somewhere..
  # just kept using hard-coded ints for now..
  # args.state.screen = {x: 0, y: 0, h: 720, w: 1280}

  args.state.players = []
  args.state.lasers = []
    # arrays of hashes


  # NOTE: move this to update player
  # p = args.state.player # must do after lazy init
  # p[:r] = p[:g] = p[:b] = (p[:health] * 25.5).clamp(0, 255)
  
  args.state.players << make_player1
  args.state.players << make_player2

end

def make_player1
  make_player x: 400,
           y: 320.randomize(:sign, :ratio),
           angle: 180,
           path: 'sprites/circle/violet.png'
           # color: { r: 255, g: 90, b: 90 }
end

def make_player2
  make_player x: 800,
           y: 250.randomize(:sign, :ratio),
           angle: 0,
           path: 'sprites/circle/green.png'
           # color: { r: 110, g: 140, b: 255 }
end

def make_player x:, y:, angle:, path:; #, color:;
  # dead: false,
  # color: color,
  # created_at: Kernel.tick_count,
  {x: x,
   y: y,
   w: 80,
   h: 80,
   path: path,
   # a: 255,
   angle: angle,
   anchor_x: 0.5,
   anchor_y: 0.5,
   vx: 0,
   vy: 0,
   trash: false, # for garbage collection
   # dead?
   cooldown: 0,
   health: 10,
   score: 0 }
end


def handle_output
  # output at the end
  args.outputs.background_color = [128, 0, 128]

  args.outputs.sprites << [args.state.players, args.state.lasers]
  
  args.state.lasers.each do |l|
    args.outputs.sprites << l.head
  end

  
  # from sample
  # args.state.clear! if args.state.player[:health] < 0 # Reset the game if the player's health drops below zero
end

def handle_logic
  # store_inputs
  # move_players
  # shoot_players
  handle_lasers
    # extend
    # reflect
      # add new laser
  # TODO:
  # check_laser_collisions args
    # do after reflect and shoot_players, 'cause they add new lasers
end

def check_laser_collisions
  # TODO: incomplete
  args.state.lasers.each do |l| # loop players or lasers?
    args.state.players.each do |p|

      # TODO: dunno about any of this, it's from the sample
      # args.state.enemies.reject! do |enemy| # TODO: reject, but no conditional..?
      # args.state.player_bullets.any? do |bullet| # TODO: LEARN: any, no conditional
      # TODO: should center sprite anchors, especially player
        # Check if enemy and player are within 20 pixels of each other (i.e. overlapping)
      if 1000 > (l.x - p.x ** 2 + (l.y - p.y) ** 2)
        # l.trash ||= true
          # nahhh, keep laser
        # kill player
        p.trash ||= true
      end
    
    end
  end
end


# TODO: surely exists somewhere..
def handle_lasers
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
      
      make_laser ({x: l.head.x, y: l.head.y, dx: dx, dy: dy})
    end

  end
end

# def reflect_angle angle
#   180 - angle
# end

# remove arrays 'n hashes all at once
def take_out_the_trash
# "For what it’s worth, you could implement this behavior yourself — instead of calling “delete”, you could set obj.garbage = true. After your iteration, then you only need array.reject!(&:garbage) to clean up." - pvande
  args.state.lasers.reject!(&:trash) # TODO: learn &:key
  args.state.players.reject!(&:trash)
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


end # class game
