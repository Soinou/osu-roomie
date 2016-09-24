React = require "react"
{Table, Tooltip, OverlayTrigger} = require "react-bootstrap"

Beatmaps = require "../../stores/BeatmapStore"
UserCell = require "./UserCell"
Mods = require "../../utils/Mods"

module.exports = React.createClass

    getInitialState: ->
        beatmap: null
        error: null
        collapsed: true

    componentWillMount: ->
        @isUnmounted = false
        id = @props.game.beatmap_id
        mode = @props.game.play_mode
        Beatmaps.findOrAdd id, mode,  (error, beatmap) =>
            if not @isUnmounted
                @setState
                    beatmap: beatmap
                    error: error

    componentWillUnmount: ->
        @isUnmounted = true

    renderScores: ->
        headers = []
        columns = []
        count = 0

        scores = @props.game.scores.sort (left, right) ->
            # Left passed, right failed, left is better
            if left.pass is "1" and right.pass is "0"
                return -1
            # Left failed, right passed, right is better
            else if left.pass is "0" and right.pass is "1"
                return 1
            # Else, the two passed or the two failed, use the score
            else
                return right.score - left.score

        for score in scores
            if score.pass is "0"
                score_cell = <span className="text-danger">{score.score}</span>
            else
                score_cell = score.score
            headers.push <UserCell key={count} id={score.user_id} />
            columns.push <td key={count}>{score_cell}</td>
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

    renderMods: ->
        items = []
        count = 0

        mods = Mods.get_mods @props.game.mods

        style =
            height: "35px"

        for mod in mods
            id = @props.game.game_id + "_" + mod.id
            tooltip = <Tooltip id={id}>{mod.name}</Tooltip>
            overlayProps =
                key: count
                placement: "top"
                overlay: tooltip
            imgProps =
                src: "/img/mods/" + mod.id + ".png"
                style: style
            items.push <OverlayTrigger {...overlayProps}>
                <img {...imgProps} />
            </OverlayTrigger>
            count++

        return items

    toggle: (e) ->
        @setState collapsed: !@state.collapsed

    toggleBlacklist: (e) ->
        @props.onChange @props.game.game_id, not e.target.checked

    render: ->
        if not @state.beatmap?
            <p>
                <i className="fa fa-circle-o-notch fa-spin"></i>
            </p>
        else if @state.error?
            <p>Error: {@state.error.toString()}</p>
        else
            game = @props.game

            start = moment game.start_time
            end = moment game.end_time

            duration = moment.utc(end.diff(start)).format "HH:mm:ss"

            beatmap = @state.beatmap.data

            title = <a href={"https://osu.ppy.sh/b/" + beatmap.beatmap_id} target="_blank">
                {beatmap.artist + " - " + beatmap.title + " [" + beatmap.version + "]"}
            </a>

            blacklisted = @props.room.blacklist[game.game_id]

            <div className="panel panel-primary">
                <div className="panel-heading">
                    <h3 className="panel-title">
                        <input type="checkbox" checked={not blacklisted} onChange={@toggleBlacklist} />
                        &nbsp;
                        <img className="hidden-xs hidden-sm" src={"https://b.ppy.sh/thumb/" + beatmap.beatmapset_id + ".jpg"} />
                        &nbsp;
                        {title}
                        &nbsp;
                        ({duration})
                        &nbsp;
                        {@renderMods()}
                    </h3>
                </div>
                {@renderScores()}
            </div>
