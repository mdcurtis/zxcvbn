
MATCHERS = DICTIONARY_MATCHERS.concat [
  l33t_match,
  digits_match, year_match, date_match,
  repeat_match, sequence_match,
  spatial_match
]

GRAPHS =
  'qwerty': qwerty
  'dvorak': dvorak
  'keypad': keypad
  'mac_keypad': mac_keypad

# on qwerty, 'g' has degree 6, being adjacent to 'ftyhbv'. '\' has degree 1.
# this calculates the average over all keys.
calc_average_degree = (graph) ->
  average = 0
  for key, neighbors of graph
    average += (n for n in neighbors when n).length
  average /= (k for k,v of graph).length
  average

KEYBOARD_AVERAGE_DEGREE     = calc_average_degree(qwerty)
KEYPAD_AVERAGE_DEGREE       = calc_average_degree(keypad) # slightly different for keypad/mac keypad, but close enough

KEYBOARD_STARTING_POSITIONS = (k for k,v of qwerty).length
KEYPAD_STARTING_POSITIONS   = (k for k,v of keypad).length

time = -> (new Date()).getTime()

# now that frequency lists are loaded, replace zxcvbn stub function.
zxcvbn = (password, user_inputs) ->
  start = time()
  if user_inputs?
    for i in [0...user_inputs.length]
      # update ranked_user_inputs_dict.
      # i+1 instead of i b/c rank starts at 1.
      ranked_user_inputs_dict[user_inputs[i].toLowerCase()] = i + 1
  matches = omnimatch password
  result = minimum_entropy_match_sequence password, matches
  result.calc_time = time() - start
  result

# make zxcvbn function globally available
# via window or exports object, depending on the environment
if window?
  window.zxcvbn = zxcvbn
  window.zxcvbn_load_hook?() # run load hook from user, if defined
else if exports?
  exports.zxcvbn = zxcvbn
