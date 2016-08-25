compression = require "compression"
express = require "express"
path = require "path"

# Create app
app = express()

# Middleware
app.use compression()

console.log "Dirname", __dirname
console.log "CWD", process.cwd()
console.log "PWD", process.env.PWD

# Static assets
app.use "/static", express.static path.join(process.env.PWD, "/public")

# Catch all
app.get "/*", (req, res) -> res.sendFile __dirname + "/public/index.html"

# Port
port = process.env.PORT || 5000

# Start app
app.listen port, -> console.log "Listening on port " + port
