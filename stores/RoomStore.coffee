Store = require "./Store"

Api = require "../services/ApiService"

# Room store
class RoomStore extends Store

    # Constructor
    constructor: ->
        super "rooms"
        @rooms = @get() or []
        @adds = {}
        @refreshes = {}

    # Add a new room
    add: (id, callback) ->

        # Already exists, send back the error
        if @find(id)? then return callback new Error "Room already exists"

        # If we already have something adding
        if @adds[id]?
            # Just add this callback
            return @adds[id].push callback

        # We don't have anything so we create a new array of callbacks
        @adds[id] = [callback]

        # Get the room
        Api.getRoom id, (error, data) =>
            # Room is null for now
            room = null

            # If we don't have any error
            if not error?
                # Whitelist all the beatmaps
                blacklist = {}
                for game in data.games
                    blacklist[game.game_id] = false

                # Create a new room
                room =
                    id: id
                    data: data
                    blacklist: blacklist
                    settings:
                        pointsTable: []

                # Store it
                @rooms.push room
                @set @rooms

            # Process all the callbacks
            for callback in @adds[id]
                callback error, room

            # Delete our callback array
            delete @adds[id]

    # Get a specific room
    find: (id) ->
        for room in @rooms
            if room.id is id
                return room
        return null

    # Get all the rooms
    all: -> return @rooms

    # Updates the blacklisted state of a beatmap
    updateBlacklist: (id, beatmap_id, state) ->
        room = @find id

        if room?
            room.blacklist[beatmap_id] = state
            @set @rooms

        return room

    updatePointsTable: (id, table) ->
        room = @find id

        if room?
            room.settings.pointsTable = table
            @set @rooms

        return room

    # Refreshes a room data
    refresh: (id, callback) ->
        # Get the room
        room = @find id

        # No room
        if not room? then callback new Error "Room doesn't exist"

        # Already refreshing, store the callback
        if @refreshes[id]? then return @refreshes[id].push callback

        # Store the callback in a new array of callbacks
        @refreshes[id] = [callback]

        # Get the room data
        Api.getRoom id, (error, data) =>
            # No error, update the room
            if not error?
                room.data = data
                @set @rooms

            # Process all the callbacks
            for callback in @refreshes[id]
                callback error, room

            # Delete the callback array
            delete @refreshes[id]

    # Deletes a room
    delete: (id) ->
        @rooms = @rooms.filter (room) -> room.id isnt id
        @set @rooms

# Exports
module.exports = new RoomStore
