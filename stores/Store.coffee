# Local storage
storage = window.localStorage

# A store
module.exports = class Store

    version: 1

    constructor: (@name) ->
        @name = "roomie." + @name

        @store = @rawGet()

        # Invalid version, reset data
        if not @store? or not @store["version"]? or @store["version"] isnt @version
            @store =
                version: @version
                data: null
            @save()

    rawGet: ->
        value = storage.getItem @name
        return value and JSON.parse value

    get: -> @store.data

    set: (value) ->
        @store.data = value
        @save()

    save: ->
        storage.setItem @name, JSON.stringify @store
