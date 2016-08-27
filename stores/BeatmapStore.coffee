Store = require "./Store"

Api = require "../services/ApiService"

# Beatmaps store
class BeatmapStore extends Store

    # Constructor
    constructor: ->
        super "beatmaps"
        @beatmaps = @get() or []
        @adds = []
        @refreshes = {}

    rawAdd: (id, mode, callback) ->
        callbacks = @adds.find (add) ->
            return add.is is id and add.mode is mode

        if callbacks? then return callbacks.list.push callback

        callbacks =
            id: id
            mode: mode
            list: [callback]

        index = @adds.push callbacks

        # Get the beatmap data
        Api.getBeatmap id, mode, (error, data) =>
            # Beatmap is null for now
            beatmap = null

            # If we don't have an error
            if not error?
                # Create and store a new beatmap
                beatmap =
                    id: id
                    data: data
                @beatmaps.push beatmap
                @set @beatmaps

            # Process callbacks
            for callback in callbacks.list
                callback error, beatmap

            # Delete callback array
            @adds.slice index - 1, 1

    # Add a new beatmap
    add: (id, mode, callback) ->
        if @find(id, mode)?
            callback new Error "Beatmap already exists"
        else
            @rawAdd id, mode, callback

    # Get a specific user
    find: (id, mode) ->
        for beatmap in @beatmaps
            if beatmap.id is id and beatmap.data.mode is mode
                return beatmap
        return null

    # Find or add a beatmap
    findOrAdd: (id, mode, callback) ->
        beatmap = @find id, mode
        if beatmap?
            callback null, beatmap
        else
            @rawAdd id, mode, callback

    # Get all the beatmaps
    all: -> return @beatmaps

    # Refreshes a beatmap data
    refresh: (id, mode, callback) ->
        # Find the beatmap
        beatmap = @find id, mode

        # No beatmap, throw an error
        if not beatmap?
            throw new Error "Beatmap doesn't exist"

        # Check if we are already refreshing
        if @refreshes[id]? then return @refreshes[id].push callback

        # Create a new callback array
        @refreshes[id] = [callback]

        # Get the beatmap data
        Api.getBeatmap id, mode, (error, data) =>
            # No error, update the beatmap
            if not error?
                beatmap.data = data
                @set @beatmaps

            # Process the callbacks
            for callback in @refreshes[id]
                callback error, beatmap

            # Delete the callback array
            delete @refreshes[id]

    # Deletes a beatmap
    delete: (id, mode) ->
        @beatmaps = @beatmaps.filter (beatmap) ->
            beatmap.id isnt id and beatmap.mode isnt mode
        @set @beatmaps

# Exports
module.exports = new BeatmapStore
