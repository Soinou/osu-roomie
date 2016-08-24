Store = require "./Store"

Api = require "../services/ApiService"

# User store
class UserStore extends Store

    # Constructor
    constructor: ->
        @users = @get("roomie.users") or []
        @adds = {}
        @refreshes = {}

    rawAdd: (id) ->
        # Get the already (maybe) existing promise
        promise = @adds[id]

        # If we have one, then return it
        if promise? then return promise

        # Else, create a new one and store it
        @adds[id] = promise = Api.getUser(id).then (data) =>
            user =
                id: id
                data: data
            @users.push user
            delete @adds[id]
            @set "roomie.users", @users
            return user

        return promise

    # Add a new user
    add: (id) ->
        user = @find id
        if user? then throw new Error "User already exists"
        return @rawAdd id

    # Get a specific user
    find: (id) ->
        return @users.find (user) -> user.id is id

    # Find or add a user
    findOrAdd: (id) ->
        user = @find id
        if user?
            return Promise.resolve user
        else
            return @rawAdd id

    # Get all the users
    all: -> return @users

    # Refreshes a user data
    refresh: (id) ->
        # Find the user
        user = @find id

        # No user, throw an error
        if not user?
            throw new Error "User doesn't exist"

        # Check if we already are refreshing this user
        promise = @refreshes[id]

        # If we are, return the refreshing promise
        if promise? then return promise

        # Else, store the refreshing promise
        @refreshes[id] = Api.getUser(id).then (data) =>
            user.data = data
            delete @refreshes[id]
            @set "roomie.users", @users

    # Deletes an user
    delete: (id) ->
        @users = @users.filter (user) -> user.id isnt id
        @set "roomie.users", @users

# Exports
module.exports = new UserStore
