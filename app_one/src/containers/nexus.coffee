

home = rc require('../scenes/home.coffee').default
fx_dash_home = rc require('../scenes/fx_dash_home.coffee').default

render = ->
    # home()
    fx_dash_home()

comp = rr
    render: render

map_state_to_props = (state) ->
    {}

map_dispatch_to_props = (dispatch) ->
    {}

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
