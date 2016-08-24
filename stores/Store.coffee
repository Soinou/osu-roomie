# Local storage
storage = window.localStorage

# A store
module.exports = class Store

    get: (key) ->
        value = storage.getItem key
        return value && JSON.parse value

    set: (key, value) ->
        storage.setItem key, JSON.stringify value
