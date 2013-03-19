#jshint forin:false
class TinyTotalizer
  _standardize = [
    (s) => s
    (s) => s.toLowerCase()
    (s) => s.toLowerCase().replace /\s/g, ''
  ]

  constructor: (@opt = {}, @hash = {}) ->
    @opt.allowMinus ?= true
    @opt.fuzzyLevel ?= 0
    if @opt.standardizer instanceof Function
      @opt.fuzzyLevel = _standardize.length
      _standardize.push @opt.standardizer
    for k, v of @hash
      if typeof v is 'number'
        @hash[k] = 0 if not @opt.allowMinus and v < 0
      else
        if typeof v is 'string'
          v = v.trim()
          if /^\d+$/.test v
            @hash[k] = Number v
            continue
        delete @hash[k]

  _match = (key) ->
    return key if @hash.hasOwnProperty key
    mk = _standardize[@opt.fuzzyLevel] key
    hk = (k for k of @hash when mk is _standardize[@opt.fuzzyLevel](k)) ? []
    hk[0] ? key

  _calc = (key, n) ->
    mKey = _match.call @, key, @opt.fuzzyLevel
    @hash[mKey] ?= 0
    @hash[mKey] += n
    @hash[mKey] = 0 if @hash[mKey] < 0 and not @opt.allowMinus
    @hash[mKey]

  _fixNumber = (n) ->
    return n if typeof n is 'number'
    if typeof n is 'string'
      return Number n if /^\d+$/.test n.trim()
    0

  add: (key, n = 1) => _calc.call @, key, _fixNumber(n)

  sub: (key, n = 1) => _calc.call @, key, _fixNumber(n) * -1

  ranking: (opt = {}) =>
    ary = (name: name, count: count for name, count of @hash when not opt.border or count >= opt.border)
    if opt.asc
      ary.sort (a, b) -> a.count - b.count
    else
      ary.sort (a, b) -> b.count - a.count
    ary.length = Math.min ary.length, (opt.topN ? ary.length)
    ary

module.exports = TinyTotalizer
