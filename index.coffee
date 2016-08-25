express = require "express"
app = express()
app.use express.static "public"
app.get "*", (req, res) -> res.sendFile __dirname + "/public/index.html"
app.listen 3000, "0.0.0.0", -> console.log "Listening on 0.0.0.0:3000"
