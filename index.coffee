express = require "express"
compression = require "compression"

# Create app
app = express()

# Middleware
app.use compression()

# Static assets
app.use "/static", express.static __dirname + "/public"

# Catch all
app.get "/*", (req, res) -> res.sendFile __dirname + "/public/index.html"

# Port
port = process.env.PORT || 5000

# Start app
app.listen port, -> console.log "Listening on port " + port
