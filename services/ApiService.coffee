{get} = require "http"

Settings = require "../stores/SettingStore"

class ApiService

    _fetch: (path, params, callback) ->
        key = Settings.getApiKey() or ""

        url = "https://osu.ppy.sh/api/" + path + "?k=" + key

        for key, value of params
            url += "&" + key + "=" + value

        request = get url, (res) ->
            data = ""
            res.setEncoding "utf8"
            res.on "data", (chunk) -> data += chunk
            res.on "end", () -> callback null, JSON.parse data

        request.on "error", (error) ->
            if error.message is "Failed to fetch"
                callback new Error "Invalid API key, please provide a valid one"
            else
                callback error

    getBeatmap: (id, mode, callback) ->
        @_fetch "get_beatmaps", {b:id, m:mode}, (error, json) ->
            if error?
                callback error
            else if json.length is 0
                callback new Error "Beatmap doesn't exist"
            else
                callback null, json[0]

    getUser: (id, callback) ->
        @_fetch "get_user", {u: id, m: 0, type: "id"}, (error, json) ->
            if error?
                callback error
            else if json.length is 0
                callback new Error "User does not exist"
            else
                callback null, json[0]

    getRoom: (id, callback) ->
        @_fetch "get_match", {mp: id}, (error, json) =>
            if error?
                callback error
            else if json.match is 0
                callback new Error "Match doesn't exist"
            else
                callback null, json

module.exports = new ApiService
