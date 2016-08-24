React = require "react"

Users = require "../../stores/UserStore"

module.exports = React.createClass

    getInitialState: ->
        user: null
        error: null

    componentWillMount: ->
        Users.findOrAdd @props.id
        .then (user) =>
            @setState user: user
        .catch (error) =>
            @setState error: error.toString()

    render: ->
        if not @state.user?
            <th>...</th>
        else if @state.error?
            <th>{@state.error}</th>
        else
            <th>{@state.user.data.username}</th>
