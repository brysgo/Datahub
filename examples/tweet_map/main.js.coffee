(dep, data, acc=[]) ->
  acc.pop() if acc.length > 10000
  coordinates = data['coordinates']?['coordinates']
  if coordinates?
    @emit(coordinates)
    acc.unshift(coordinates)
  return acc
