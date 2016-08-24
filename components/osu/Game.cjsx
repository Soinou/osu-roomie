React = require "react"
{Table} = require "react-bootstrap"

Beatmaps = require "../../stores/BeatmapStore"
UserCell = require "./UserCell"

module.exports = React.createClass

    getInitialState: ->
        beatmap: null
        error: null
        collapsed: true

    componentWillMount: ->
        Beatmaps.findOrAdd @props.game.beatmap_id
        .then (beatmap) =>
            @setState beatmap: beatmap
        .catch (error) =>
            @setState error: error.toString()

    renderScores: ->
        headers = []
        columns = []
        count = 0

        for score in @props.game.scores
            headers.push <UserCell key={count} id={score.user_id} />
            columns.push <td key={count}>{score.score}</td>
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

    toggle: (e) ->
        @setState collapsed: !@state.collapsed

    toggleBlacklist: (e) ->
        @props.onChange @props.game.game_id, not e.target.checked

    render: ->
        if not @state.beatmap?
            <p>...</p>
        else if @state.error?
            <p>{@state.error}</p>
        else
            game = @props.game

            start = moment game.start_time
            end = moment game.end_time

            duration = moment.utc(end.diff(start)).format "HH:mm:ss"

            beatmap = @state.beatmap.data

            title = beatmap.artist + " - " + beatmap.title + " [" + beatmap.version + "]"

            blacklisted = @props.room.blacklist[game.game_id]

            <div className="panel panel-default">
                <div className="panel-heading">
                    <h3 className="panel-title">
                        <input type="checkbox" checked={not blacklisted} onChange={@toggleBlacklist} />
                        &nbsp;
                        <img className="hidden-xs hidden-sm" src={"https://b.ppy.sh/thumb/" + beatmap.beatmapset_id + ".jpg"} />
                        &nbsp;
                        {title}
                        &nbsp;
                        ({duration})
                    </h3>
                </div>
                {@renderScores()}
            </div>
