(dep, data, acc={}) ->
  acc[dep] = data
  if (x for x of acc).length == 2
    @emit(acc)
  else
    return acc
