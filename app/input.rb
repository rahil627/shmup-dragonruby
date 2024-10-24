

# inputs don't change much, so put it in another file
module Input

# @param args [GTK::Args]
def handle_input
  store_inputs
  
  move_player
  shoot_player
end

# sources: started with twinstick sample
def move_player
  # p = args.state.player
  args.state.players.each do |p|

    s = p[:s] ||= 0.75 # speed
    dx, dy = args.state.in.move_vector

    # TODO: use anchor_x/y and angle_anchor_x to turn sprite
    p[:angle] = vector_to_angle(dx, dy) - 90

    # Take the weighted average of the old velocities and the desired velocities.
    # Since move_directional_vector returns values between -1 and 1,
    #   and we want to limit the speed to 7.5, we multiply dx and dy by 7.5*0.1 to get 0.75
    p[:vx] = p[:vx] * 0.9 + dx * s
    p[:vy] = p[:vy] * 0.9 + dy * s

    # move
    p.x += p[:vx]
    p.y += p[:vy]

    # bound to screen
    p.x = p.x.clamp(0, 1201)
    p.y = p.y.clamp(0, 640)
  end
end


def shoot_player
  # p = args.state.player
  args.state.players.each do |p|

    p[:cooldown] -= 1
    return if p[:cooldown] > 0
  
    cooldown_length = p[:cooldown_length] ||= 60 # 1/second
  
    dx, dy = args.state.in.shoot_vector
    return if dx == 0 and dy == 0 # if no input, return early

    # add a new bullet to the list of player bullets
    w = p.w
    h = p.h

    x = p.x + w/2 * dx
    y = p.y + h/2 * dy
    make_laser ({x: x, y: y, dx: dx, dy: dy})
  
    # vs seperate sprite
    # args.state.laser_heads << { x: x, y: y, w: 5, h: 5, path: 'sprites/circle/green.png', angle: vector_to_angle(dx, dy) }

    p[:cooldown] = cooldown_length # reset the cooldown
  end
end

# NOTE: called during reflect
def make_laser a
  args.state.lasers << (laser a)
end

# returns entity hash
def laser a # hash with x, y, dx, dy
  w = args.state.c.laser_width ||= 20
  
  # TODO: can provide angle or vector or both?
  # angle = 0
  # if (a.angle) # TODO: a.angle or a['angle']?
  #   angle = a.angle
  #   dx = Math.sin(angle)
  #   dy = Math.cos(angle)
  # else
  #   dx = a.dx
  #   dy = a.dy
  #   angle = vector_to_angle(a.dx, a.dy) - 90
  # end

  {
    x:     a.x,
    y:     a.y,
    anchor_x: 0.5, # center of width of laser
    # anchor_y: 0.5,
    w:     w,
    h:     1, # 0 might cause multiplication problem..
    path: :pixel,
    angle: vector_to_angle(a.dx, a.dy) - 90,
      # Rotation of the sprite in degrees (default value is 0). Rotation occurs around the center of the sprite. The point of rotation can be changed using angle_anchor_x and angle_anchor_y.
    # angle_anchor_x: 0.5,
    angle_anchor_y: 0, # don't quite remember.. bottom of length of laser?
    r:     255 * rand, g: 255 * rand, b: 255 * rand, # white by default
    # vx:    10 * dx + args.state.player[:vx] / 7.5,
    # vy: 10 * dy + args.state.player[:vy] / 7.5, # Factor in a bit of the player's velocity

    # extra fields
    # player: player_id
    trash: false, # not necessary, as ||= and {}.reject! will work without it
    dx: a.dx, # more convenient than angle..
    dy: a.dy,
    head: { x: a.x, y: a.y, w: 5, h: 5, path: :pixel, r: 0, g: 255, b: 0}, # composition..??
  }
end

# TODO: is there a proper name for this..?
# input [dx, dy]
# output angle in degrees
def vector_to_angle(dx, dy)
  Math.atan2(dy, dx).to_degrees # NOTE: y,x
end


# INPUTS HANDLED HERE

# store all inputs into global state
# also makes testing inputs easy
def store_inputs
  args.state.in.shoot_vector ||= [0, 0]
  args.state.in.move_vector ||= [0, 0]
  args.state.in.shoot_vector = (get_shoot_vector)
  args.state.in.move_vector = (get_move_vector)
end

# stores the directional vector of movement input into args.state.in.move_vector
# TODO: should use left_right_perc and up_down_perc, which conveniently combines wasd/arrows/analog
# TODO: multiple controllers, see $args.inputs.controllers
# TEMP: use WASD
def get_move_vector

  s = args.state.c.player_move_speed ||= 0.7071
  # dx = args.inputs.left_right_perc # handles wasd, arrows, analog sticks
  # dy = args.inputs.up_down_perc
  
  dx = 0
  dx += 1 if args.inputs.keyboard.d
  dx -= 1 if args.inputs.keyboard.a
  dy = 0
  dy += 1 if args.inputs.keyboard.w
  dy -= 1 if args.inputs.keyboard.s
  if dx != 0 and dy != 0
    dx *= s
    dy *= s
  end
  [dx, dy]
  # NOTE: magically can do: dx, dy = move_directional_vector
end

# stores the directional vector of shoot input into args.state.in.shoot_vector
# TEMP: use arrow keys
def get_shoot_vector

  s = args.state.c.player_shot_speed ||= 0.7071
  dx = args.inputs.left_right_directional # arrows, d-pad
  dy = args.inputs.up_down_directional
  
  # dx = 0
  # dx += 1 if args.inputs.keyboard.key_down.right || args.inputs.keyboard.key_held.right
  # dx -= 1 if args.inputs.keyboard.key_down.left || args.inputs.keyboard.key_held.left
  # dy = 0
  # dy += 1 if args.inputs.keyboard.key_down.up || args.inputs.keyboard.key_held.up
  # dy -= 1 if args.inputs.keyboard.key_down.down || args.inputs.keyboard.key_held.down
  if dx != 0 and dy != 0
    dx *= s
    dy *= s
  end
  [dx, dy]
end


end # module

