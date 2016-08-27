React = require "react"
async = require "async"
{Button, Table} = require "react-bootstrap"
{LinkContainer} = require "react-router-bootstrap"

Computer = require "../../services/ComputerService"
EditRoomSettings = require "../dialogs/EditRoomSettings"
Game = require "../osu/Game"
Rooms = require "../../stores/RoomStore"
UserCell = require "../osu/UserCell"
Users = require "../../stores/UserStore"

module.exports = React.createClass

    getInitialState: ->
        waiting: false
        showSettings: false
        room: null
        points: null

    update: (room, error) ->
        if not error? then error = null
        if room?
            points = Computer.compute room
            @setState
                waiting: false
                room: room
                points: points
                error: error

    componentWillMount: ->
        @isUnmounted = false
        @update Rooms.find @props.params.id

    componentWillReceiveProps: (nextProps) ->
        @update Rooms.find nextProps.params.id

    componentWillUnmount: ->
        @isUnmounted = true

    renderGames: ->
        games = []
        count = 0

        for game in @state.room.data.games
            games.push <Game
                key={count}
                room={@state.room}
                game={game}
                onChange={@toggleBlacklist}
            />
            count++

        return games

    renderScores: ->
        columns = []
        headers = []
        count = 0

        for score in @state.points
            headers.push <UserCell key={count} id={score.id}></UserCell>
            columns.push <td key={count}>{score.points}</td>
            count++

        <Table responsive bordered striped condensed>
            <thead>
                <tr>
                    {headers}
                </tr>
            </thead>
            <tbody>
                <tr>
                    {columns}
                </tr>
            </tbody>
        </Table>

    renderBody: ->
        if @state.waiting
            <p>
                <i className="fa fa-circle-o-notch fa-spin"></i>
            </p>
        else if @state.error?
            <p>Error: {@state.error.toString()}</p>
        else if not @state.room?
            <p>Room doesn't exist</p>
        else
            # Room data
            data = @state.room.data

            # Match
            match = data.match

            # Games
            games = data.games

            # Start and end time
            start = moment(match.start_time).format "DD/MM/YYYY HH:mm:ss"
            end = moment(match.end_time)

            if end.isValid()
                end = end.format "DD/MM/YYYY HH:mm:ss"
            else
                end = "In progress"

            backStyle =
                position: "fixed"
                left: "5px"
                bottom: "5px"

            refreshStyle =
                position: "fixed"
                right: "5px"
                bottom: "5px"

            <div>
                <h3>General</h3>
                <div className="panel panel-primary">
                    <LinkContainer to="/" style={backStyle}>
                        <Button bsStyle="primary">Back</Button>
                    </LinkContainer>
                    <Button bsStyle="primary" style={refreshStyle} onClick={@refresh}>
                        Refresh
                    </Button>
                    <div className="panel-heading">
                        <h3 className="panel-title">
                            <span className="pull-left">
                                {match.name}
                                &nbsp;
                                <a href="#" onClick={@settings}>
                                    <i className="fa fa-gear" style={{color: "white"}}></i>
                                </a>
                            </span>
                            <span className="pull-right">{start} - {end}</span>
                            <span className="clearfix" />
                        </h3>
                    </div>
                    {@renderScores()}
                </div>

                <h3>History</h3>

                {@renderGames()}

                <EditRoomSettings
                    show={@state.showSettings}
                    room={@state.room}
                    onHide={@handleHide}
                />
            </div>

    render: ->
        <div>
            {@renderBody()}
        </div>

    refresh: ->
        Rooms.refresh @props.params.id, (error, room) => @update room, error
        @setState waiting: true

    toggleBlacklist: (id, value) ->
        @update Rooms.updateBlacklist @props.params.id, id, value

    settings: ->
        @setState showSettings: true

    handleHide: ->
        @setState showSettings: false
        @update Rooms.find @props.params.id
