Store = require "./Store"

# Setting store
class SettingStore extends Store

    # Set api key
    setApiKey: (apiKey) ->
        @set "roomie.apiKey", apiKey

    # Get api key
    getApiKey: ->
        return @get "roomie.apiKey"

# Exports
module.exports = new SettingStore
