express = require "express"

app = express()

app.set "view engine", "pug"

app.use express.static "public", etag: false

app.get "*", (req, res) -> res.render "app"

app.listen 3000, "0.0.0.0", ->

    console.log "Listening on 0.0.0.0:3000"
