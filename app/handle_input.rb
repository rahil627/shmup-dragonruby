def handle_input args
  move_player args
end

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


# Custom function for getting a directional vector just for movement using WASD
def move_directional_vector args
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
  [dx, dy]
end

# TODO: unused?
# Custom function for getting a directional vector just for shooting using the arrow keys
def shoot_directional_vector args
  dx = 0
  dx += 1 if args.inputs.keyboard.key_down.right || args.inputs.keyboard.key_held.right
  dx -= 1 if args.inputs.keyboard.key_down.left || args.inputs.keyboard.key_held.left
  dy = 0
  dy += 1 if args.inputs.keyboard.key_down.up || args.inputs.keyboard.key_held.up
  dy -= 1 if args.inputs.keyboard.key_down.down || args.inputs.keyboard.key_held.down
  if dx != 0 && dy != 0
    dx *= 0.7071
    dy *= 0.7071
  end
  [dx, dy]
end
