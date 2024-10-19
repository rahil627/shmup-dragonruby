

# inputs don't change much, so put it in another file

def handle_input args
  move_player args
  fire_player args
end

# from twinstick sample
def move_player args
  # Get the currently held direction.
  dx, dy                 = move_directional_vector args
  # Take the weighted average of the old velocities and the desired velocities.
  # Since move_directional_vector returns values between -1 and 1,
  #   and we want to limit the speed to 7.5, we multiply dx and dy by 7.5*0.1 to get 0.75
  args.state.player[:vx] = args.state.player[:vx] * 0.9 + dx * 0.75
  args.state.player[:vy] = args.state.player[:vy] * 0.9 + dy * 0.75
  # Move the player
  args.state.player.x    += args.state.player[:vx]
  args.state.player.y    += args.state.player[:vy]
  # If the player is about to go out of bounds, put them back in bounds.
  args.state.player.x    = args.state.player.x.clamp(0, 1201)
  args.state.player.y    = args.state.player.y.clamp(0, 640)
end


def fire_player args
  args.state.player[:cooldown] -= 1
  
  return if args.state.player[:cooldown] > 0
  
  dx, dy = shoot_directional_vector args # Get the bullet velocity
  return if dx == 0 && dy == 0 # If the velocity is zero, the player doesn't want to fire. Therefore, we just return early.

  # Add a new bullet to the list of player bullets.
  puts "fire_player"
  x = args.state.player.x + args.state.player.w * dx
  y = args.state.player.y + args.state.player.h * dy
  make_laser args, {x: x, y: y, dx: dx, dy: dy}
  
  # vs seperate sprite
  # args.state.laser_heads << { x: x, y: y, w: 5, h: 5, path: 'sprites/circle/green.png', angle: vector_to_angle(dx, dy) }

  args.state.player[:cooldown] = 30 # Reset the cooldown
end

# called during reflect
def make_laser (args, a)
  l = args.state.c.laser_length ||= 20
  
  args.state.lasers << { # could avoid passing in args, but.. meh. it's neater this way!
  # {
    x:     a.x,
    y:     a.y,
    w:     l,
    h:     l,
    path: :pixel,
    angle: vector_to_angle(a.dx, a.dy) - 90,
      # Rotation of the sprite in degrees (default value is 0). Rotation occurs around the center of the sprite. The point of rotation can be changed using angle_anchor_x and angle_anchor_y.
    # angle_anchor_x: 0,
    angle_anchor_y: 0,
    r:     255 * rand, g: 255 * rand, b: 255 * rand, # white by default
    # vx:    10 * dx + args.state.player[:vx] / 7.5,
    # vy: 10 * dy + args.state.player[:vy] / 7.5, # Factor in a bit of the player's velocity

    # extra fields
    # player: player_id
    trash: false,
    dx: a.dx, # more convenient than angle..
    dy: a.dy,
    head: { x: a.x, y: a.y, w: 5, h: 5, path: :pixel, r: 0, g: 255, b: 0}, # TODO: composition..? TODO: learn array vs hash
  }
end

# TODO: is there a proper name for this..?
# input [dx, dy]
# output angle in degrees
def vector_to_angle(dx, dy)
  Math.atan2(dy, dx).to_degrees # NOTE: y,x
end


# INPUTS HANDLED HERE

# Custom function for getting a directional vector just for movement
# TODO: should use left_right_perc and up_down_perc, which conveniently combines wasd/arrows/analog
# TEMP: use WASD
def move_directional_vector args
  # dx = args.inputs.left_right_perc # handles wasd, arrows, analog sticks
  # dy = args.inputs.up_down_perc
  
  dx = 0
  dx += 1 if args.inputs.keyboard.d
  dx -= 1 if args.inputs.keyboard.a
  dy = 0
  dy += 1 if args.inputs.keyboard.w
  dy -= 1 if args.inputs.keyboard.s
  if dx != 0 && dy != 0
    dx *= 0.7071
    dy *= 0.7071
  end
  # args.state.in.move_vector ||= [dx, dy]
  [dx, dy]
  # NOTE: magically can do: dx, dy = move_directional_vector
end

# Custom function for getting a directional vector just for shooting
# TEMP: use arrow keys
def shoot_directional_vector args
  dx = args.inputs.left_right_directional # arrows, d-pad
  dy = args.inputs.up_down_directional
  
  # dx = 0
  # dx += 1 if args.inputs.keyboard.key_down.right || args.inputs.keyboard.key_held.right
  # dx -= 1 if args.inputs.keyboard.key_down.left || args.inputs.keyboard.key_held.left
  # dy = 0
  # dy += 1 if args.inputs.keyboard.key_down.up || args.inputs.keyboard.key_held.up
  # dy -= 1 if args.inputs.keyboard.key_down.down || args.inputs.keyboard.key_held.down
  if dx != 0 && dy != 0
    dx *= 0.7071
    dy *= 0.7071
  end
  # args.state.in.shoot_vector ||= [dx, dy]
  [dx, dy]
end
