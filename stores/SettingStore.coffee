Store = require "./Store"

# Setting store
class SettingStore extends Store

    constructor: ->
        super "settings"
        @settings = @get() or {apiKey: ""}

    # Set api key
    setApiKey: (apiKey) ->
        @settings["apiKey"] = apiKey
        @set @settings

    # Get api key
    getApiKey: ->
        return @settings["apiKey"]

# Exports
module.exports = new SettingStore
