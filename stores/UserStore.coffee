Store = require "./Store"

Api = require "../services/ApiService"

# User store (Same thing as the beatmap store)
class UserStore extends Store

    constructor: ->
        super "users"
        @users = @get() or []
        @adds = {}
        @refreshes = {}

    rawAdd: (id, callback) ->
        if @adds[id]? then return @adds[id].push callback
        @adds[id] = [callback]
        Api.getUser id, (error, data) =>
            user = null
            if not error?
                user =
                    id: id
                    data: data
                @users.push user
                @set @users
            for callback in @adds[id]
                callback error, user
            delete @adds[id]

    add: (id, callback) ->
        if @find(id)?
            callback new Error "User already exists"
        else
            @rawAdd id, callback

    find: (id) ->
        for user in @users
            if user.id is id
                return user
        return null

    findOrAdd: (id, callback) ->
        user = @find id
        if user?
            callback null, user
        else
            @rawAdd id, callback

    all: -> return @users

    refresh: (id, callback) ->
        user = @find id
        if not user?
            callback new Error "User doesn't exist"
        if @refreshes[id]? then return @refreshes[id].push callback
        @refreshes[id] = [callback]
        Api.getUser id, (error, data) =>
            if not error?
                user.data = data
                @set @users
            for callback in @refreshes[id]
                callback error, user
            delete @refreshes[id]

    delete: (id) ->
        @users = @users.filter (user) -> user.id isnt id
        @set @users

# Exports
module.exports = new UserStore
