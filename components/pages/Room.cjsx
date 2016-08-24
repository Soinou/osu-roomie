React = require "react"
{Button, Table} = require "react-bootstrap"
{LinkContainer} = require "react-router-bootstrap"

Game = require "../osu/Game"
Rooms = require "../../stores/RoomStore"
Users = require "../../stores/UserStore"
Computer = require "../../services/ComputerService"

module.exports = React.createClass

    getInitialState: ->
        room: null
        points: null

    update: (room) ->
        points = Computer.compute room
        promises = []

        for user_id, score of points
            do (score) ->
                promises.push Users.findOrAdd(user_id).then (user) ->
                    score.user = user

        Promise.all promises
        .then =>
            @setState room: room, points: points

    componentWillMount: ->
        @update Rooms.find @props.params.id

    componentWillReceiveProps: (nextProps) ->
        @update Rooms.find nextProps.params.id

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

        for user_id, user_score of @state.points
            headers.push <th key={count}>{user_score.user.data.username}</th>
            columns.push <td key={count}>{user_score.score}</td>
            count++

        <Table responsive bordered striped>
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

    render: ->
        if not @state.room?
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
            end = moment(match.end_time).format "DD/MM/YYYY HH:mm:ss"

            buttonStyle =
                position: "fixed"
                left: "5px"
                bottom: "5px"

            <div>
                <LinkContainer to="/rooms" style={buttonStyle}>
                    <Button bsStyle="primary">Back</Button>
                </LinkContainer>
                <div className="panel panel-primary">
                    <div className="panel-heading">
                        <h3 className="panel-title">
                            <span className="pull-left">{match.name}</span>
                            <span className="pull-right">{start} - {end}</span>
                            <span className="clearfix" />
                        </h3>
                    </div>
                    <div className="panel-body">
                        <h4>Scores</h4>
                    </div>
                    {@renderScores()}
                    <div className="panel-body">
                        <h4>History</h4>
                        {@renderGames()}
                    </div>
                </div>
            </div>

    toggleBlacklist: (id, value) ->
        @update Rooms.updateBlacklist @props.params.id, id, value
