window.log = console.log.bind(console)

Object.assign global,
  _with: (val, fn) ->
    # test for Promise
    if Promise.resolve(val) is val
      val.then (actualVal) ->
        fn.call(actualVal, actualVal) if actualVal?
    else
      fn.call(val, val) if val?

  _when: (check, cb, ms = 30) ->
    while true
      res = check()
      if res?
        cb?.call(res, res)
        return res
      await Promise.delay(ms)


global._ = global._it = new Proxy {},
  get: (_, prop) ->
    retrieve = (props...) ->
      fn = (obj) ->
        props.reduce ((obj, prop) -> obj[prop]), obj

      if props.last() in ['is', 'isnt']
        prop = props.pop()
        switch prop
          when 'is' then (val) -> (obj) -> fn(obj) is val
          when 'isnt' then (val) -> (obj) -> fn(obj) isnt val
      else
        new Proxy fn,
          get: (_, prop) -> retrieve(props..., prop)
    retrieve(prop)


Promise.delay = (ms) ->
  new Promise (res) -> setTimeout(res, ms)


Array::whereFirst = (query) ->
  @find (e) ->
    not Object.entries(query).find ([ key, val ]) ->
      e?[key] isnt val


Array::last = ->
  @[@length - 1]
