React = require "react"

Users = require "../../stores/UserStore"

module.exports = React.createClass

    getInitialState: ->
        user: null
        error: null

    componentWillMount: ->
        Users.findOrAdd @props.id, (error, user) =>
            @setState
                user: user
                error: error

    render: ->
        if not @state.user?
            <th><i className="fa fa-circle-o-notch fa-spin"></i></th>
        else if @state.error?
            <th>Error: {@state.error.toString()}</th>
        else
            <th>
                <a href={"https://osu.ppy.sh/u/" + @state.user.id} target="_blank">
                    {@state.user.data.username}
                </a>
            </th>
