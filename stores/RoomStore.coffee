Store = require "./Store"

Api = require "../services/ApiService"

# Room store
class RoomStore extends Store

    # Constructor
    constructor: ->
        @rooms = @get("roomie.rooms") or []
        @adds = {}
        @refreshes = {}

    # Add a new room
    add: (id) ->
        if @find(id)? then throw new Error "Room already exists"

        promise = @adds[id]

        if promise? then return promise

        @adds[id] = promise = Api.getRoom(id).then (data) =>

            # Whitelist all the beatmaps
            blacklist = {}
            for game in data.games
                blacklist[game.game_id] = false

            room =
                id: id
                data: data
                blacklist: blacklist
                points: {}

            @rooms.push room
            @set "roomie.rooms", @rooms
            return room

        return promise

    # Get a specific room
    find: (id) -> return @rooms.find (room) -> room.id is id

    # Get all the rooms
    all: -> return @rooms

    # Updates the blacklisted state of a beatmap
    updateBlacklist: (id, beatmap_id, state) ->
        room = @find id

        if room?
            room.blacklist[beatmap_id] = state
            @set "roomie.rooms", @rooms

        return room

    # Updates the points of an user
    updatePoints: (id, user_id, points) ->
        room = @find id

        if room?
            room.points[user_id] = points
            @set "roomie.rooms", @rooms

        return room

    # Refreshes a room data
    refresh: (id) ->
        room = @find(id)
        if not room? then throw new Error "Room doesn't exist"

        promise = @refreshes[id]

        if promise? then return promise

        @refreshes[id] = promise = Api.getRoom(id).then (data) =>
            room.data = data
            @set "roomie.rooms", @rooms
            return room

        return promise

    # Deletes a room
    delete: (id) ->
        @rooms = @rooms.filter (room) -> room.id isnt id
        @set "roomie.rooms", @rooms

# Exports
module.exports = new RoomStore
