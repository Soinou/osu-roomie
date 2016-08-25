express = require "express"
app = express()
app.use express.static "public"
app.get "*", (req, res) -> res.sendFile __dirname + "/public/index.html"
port = process.env.PORT || 5000
app.listen port, -> console.log "Listening on port " + port
