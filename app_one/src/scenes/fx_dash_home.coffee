



process_graph = ({ the_graph }) ->
    # want to know the maximum and minimum values encountered during the graph transition so
    # will know how to scale the graph

    # reversi = _.reduce the_graph, (acc, slot, idx) ->
    #
    # , []

    reversi = for idx in [199 .. 0]
        the_graph[idx]


    c 'reversi', reversi
    c 'the_graph', the_graph

    the_stats = _.reduce reversi, (acc, slot, idx) ->
        if slot.low < acc.low then acc.low = slot.low
        if slot.high > acc.high then acc.high = slot.high
        acc
    ,
        low: reversi[0].low
        high: reversi[0].high


    c 'the_graph', the_graph

    chart_width = .8 * ww
    chart_height = .8 * wh
    price_delta = Math.abs( the_stats.low - the_stats.high )

    # c 'price_delta', price_delta
    # c 'the low', the_stats.low
    # c 'the_high', the_stats.high

    time_delta = 200

    vert_scalar = chart_height / price_delta
    # c 'vert_scalar', vert_scalar
    horiz_scalar = chart_width / time_delta


    # c 'ww', ww
    # c 'wh', wh


    initial_path = "M#{.1 * ww} #{(.9 * wh) - ((the_stats.high - the_graph[0].open) * vert_scalar)} l#{horiz_scalar} #{(the_graph[0].open - the_graph[0].close) * vert_scalar}"

    c 'initial_path', initial_path

    the_path = _.reduce the_graph, (_path, slot, idx) ->

        if idx > 0
            # c 'stuff...', slot.open, slot.close
            # c 'diffy', slot.open - slot.close
            _path += "
l0 #{-(the_graph[idx - 1].close - slot.open) * vert_scalar}
l#{horiz_scalar} #{-(slot.open - slot.close) * vert_scalar}
            "
            _path
        else
            _path
    , initial_path


    # c 'the_path', the_path



    { the_stats, the_path, reversi, vert_scalar, horiz_scalar, price_delta }



comp = rr
    componentWillMount: ->
        request.get 'https://www.fxempire.com/api/v1/en/markets/eur-usd/chart?time=min_1'
        .end (err, res) =>
            if err then c err else
                the_graph = JSON.parse res.text
                { the_stats, the_path, reversi, vert_scalar, horiz_scalar, price_delta } = process_graph { the_graph } # but will likely return some things


                @setState { the_graph, the_stats, the_path, reversi, vert_scalar, horiz_scalar, price_delta }




    getInitialState: ->
        {}

    render: ->
        # c 'the_graph', @state.the_graph
        svg
            x: 0
            y: 0
            width: ww
            height: wh
            # rect
            #     x: .1 * ww
            #     y: .2 * wh
            #     width: .3 * ww
            #     height: .4 * wh
            #     fillOpacity: .23
            #     fill: 'magenta'
            path
                d: @state.the_path
                fill: 'none'
                stroke: 'black'
                strokeWidth: .23
            # x-axis
            line
                x1: .1 * ww
                x2: .9 * ww
                y1: .9 * wh
                y2: .9 * wh
                strokeWidth: .11
                stroke: 'black'

            line
                x1: .1 * ww
                x2: .1 * ww
                y1: .1 * wh
                y2: .9 * wh
                strokeWidth: .11
                stroke: 'black'
            if @state.reversi
                c '@state.reversi', @state.reversi
                g null,
                    for idx in [0 .. 199]
                        do (idx) =>
                            if idx % 30 is 0
                                c 'idx', idx
                                c 'state.reversi[idx]', @state.reversi[idx]
                                c Date(@state.reversi[idx].date).toString()
                                c @state.reversi[idx]
                                text
                                    x: (.1 * ww) + (idx * @state.horiz_scalar)
                                    y: .93 * wh
                                    fontSize: .0083 * wh
                                    fontFamily: 'times'
                                    Date(@state.reversi[idx].date).toString()
                    for idx in [0 .. 10]
                        do (idx) =>
                            text
                                x: .03 * ww
                                y: (.108 * wh) + (idx * ((.8 * wh) / 10))
                                fontSize: .0083 * wh
                                fontFamily: 'times'
                                (@state.the_stats.high) - (idx * (@state.price_delta / 10))







map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
