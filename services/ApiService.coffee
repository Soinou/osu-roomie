fetch = require "isomorphic-fetch"

Settings = require "../stores/SettingStore"

class ApiService

    _fetch: (path, params) ->
        key = Settings.getApiKey()

        if not key? or key is ""
            throw new Error "Api key is invalid"

        url = "https://osu.ppy.sh/api/" + path + "?k=" + key

        for key, value of params
            url += "&" + key + "=" + value

        return fetch url
        .then (response) ->
            if response.status isnt 200
                throw new Error "Could not get data from osu!api. Check your osu!api key"
            else
                return response.json()

    getBeatmap: (id) ->
        @_fetch "get_beatmaps",
            b: id
            m: 0
        .then (data) ->
            if data.length is 0
                throw new Error "Beatmap does not exist."
            else
                return data[0]

    getUser: (id) ->
        @_fetch "get_user",
            u: id
            m: 0
            type: "id"
        .then (data) ->
            if data.length is 0
                throw new Error "Beatmap does not exist."
            else
                return data[0]

    getRoom: (id) ->
        @_fetch "get_match",
            mp: id
        .then (data) ->
            if data.match is 0
                throw new Error "Match doesn't exist"
            else
                return data

module.exports = new ApiService
