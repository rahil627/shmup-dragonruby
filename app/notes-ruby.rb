# TODO: merge in ruby.txt

# basics
return if args.state.player[:cooldown] > 0
  # statement if condition



# functions
def function args1 not2
  # need to add parenthesis for two or more arguments
end

def f(arg) end
f (a: 22, b: 33)
f {a: 22, b: 33} # same

def f(a:, b:) end
f (a: 22, b: 33)
f {a: 22, b: 33}
hash_arg = {a: 22, b: 33}
kw_arg_function hash_arg # deprecated in v3/v3.1 mruby
kw_arg_function **hash_arg # workaround

hash_gen_keywords {a:, b:, c:} # -> {a: a, b: b, c: c}

make_laser args, a
make_laser args, {x: x, y: y, w: l, h: l, dx: dx, dy: dy}

# DragonRuby's recommended use of parenthesis (inner function has parenthesis).
puts (add_one_to 3) # inner
puts add_one_to(3) # "conventional"
puts(add_one_to 3) # outer
puts(add_one_to(3)) # all
  



# hashes and arrays
Array is one of the most powerful classes in Ruby and a very fundamental component of Game Toolkit.

A Hash has certain similarities to an Array, but:
An Array index is always an Integer.
A Hash key can be (almost) any object.

An Array is an ordered, integer-indexed collection of objects, called elements. Any object (even another array) may be an array element, and an array can contain objects of different types.


**hash
*array
  # These are splat operators, they'll deconstruct your hash/array into arguments for a method. 

target = { x: 50, y: 50 }
def move_to(x:, y:)
  # moves player to x, y
end
move_to(**target)
  # hash splat

target = [50, 50]
def move_to(x, y)
  # moves player to x, y
end
move_to(*target)
  # array splat


old_hash = { a: 1, b: 2 }
hash = { a: 5, **old_hash, b: 6 } # => { a: 1, b: 6 }
  # args replaced by order of precedence

old_array = [2, 3, 4 , 5]
array = [ 1, 2, *old_array, 5, 6] # => [1, 2, 2, 3, 4, 5, 5, 6]
  # not for arrays tho..

"hashsplat is useful for moments when ~'a lot of the things i want to output are similar'"

## hashes
screen ||= {0, 0, 720, 1280} # error
screen ||= {x: 0, y: 0, h: 720, w: 1280} # hashes need keys


## arrays





  

# from getting started tutorial
   
args.outputs.labels << [580, 400, 'Hello World!']
  # The "<<" thing says "append this array onto the list of them at args.outputs.labels)
  
args.state.rotation ||= 0
  # shorthand for "if args.state.rotation isn't initialized, set it to zero." It's a nice way to embed your initialization code right next to where you need the variable.
  #  - amazing..!

args.state.laser.trash ||= true
  # nested field mades on-the-fly..?



# loops
# loops are quite different..
3.times do |i|
  puts i
end

array = ["a", "b", "c", "d"]
array.each do |char|
  puts char
end  

array = ["a", "b", "c", "d"]
array.each do |char, i|
  puts "index #{i}: #{char}"
end

# puts "** INFO: range block exclusive (three dots)"
(0...3).each do |i|
  puts i
end

# puts "** INFO: range block inclusive (two dots)"
(0..3).each do |i|
  puts i
end
