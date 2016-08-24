Store = require "./Store"

Api = require "../services/ApiService"

# Beatmaps store
class BeatmapStore extends Store

    # Constructor
    constructor: ->
        @beatmaps = @get("roomie.beatmaps") or []
        @adds = {}
        @refreshes = {}

    rawAdd: (id) ->
        # Get the already (maybe) existing promise
        promise = @adds[id]

        # If we have one, then return it
        if promise? then return promise

        # Else, create a new one and store it
        @adds[id] = promise = Api.getBeatmap(id).then (data) =>
            beatmap =
                id: id
                data: data
            @beatmaps.push beatmap
            delete @adds[id]
            @set "roomie.beatmaps", @beatmaps
            return beatmap

        return promise

    # Add a new beatmap
    add: (id) ->
        beatmap = @find id
        if beatmap? then throw new Error "Beatmap already exists"
        return @rawAdd id

    # Get a specific user
    find: (id) ->
        return @beatmaps.find (beatmap) -> beatmap.id is id

    # Find or add a beatmap
    findOrAdd: (id) ->
        beatmap = @find id
        if beatmap?
            return Promise.resolve beatmap
        else
            return @rawAdd id

    # Get all the beatmaps
    all: -> return @beatmaps

    # Refreshes a beatmap data
    refresh: (id) ->
        # Find the beatmap
        beatmap = @find id

        # No beatmap, throw an error
        if not beatmap?
            throw new Error "Beatmap doesn't exist"

        # Check if we already are refreshing this beatmap
        promise = @refreshes[id]

        # If we are, return the refreshing promise
        if promise? then return promise

        # Else, store the refreshing promise
        @refreshes[id] = Api.getBeatmap(id).then (data) =>
            beatmap.data = data
            delete @refreshes[id]
            @set "roomie.beatmaps", @beatmaps

    # Deletes an user
    delete: (id) ->
        @beatmaps = @beatmaps.filter (beatmap) -> beatmap.id isnt id
        @set "roomie.beatmaps", @beatmaps

# Exports
module.exports = new BeatmapStore
