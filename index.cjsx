# Libraries
React = require "react"
{Router, Route, IndexRoute, browserHistory} = require "react-router"
{render} = require "react-dom"

# Components
App = require "./components/App"
Index = require "./components/pages/Index"
NotFound = require "./components/pages/NotFound"
Room = require "./components/pages/Room"
Rooms = require "./components/pages/Rooms"

# Root
Root = React.createClass

    render: ->
        <Router history={browserHistory}>
            <Route path="/" component={App}>
                <IndexRoute component={Rooms} />
                <Route path="/:id" component={Room} />
            </Route>
        </Router>

# Render root
render <Root />, document.getElementById "root"
