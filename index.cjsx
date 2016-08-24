# Libraries
React = require "react"
{Router, Route, IndexRoute, browserHistory} = require "react-router"
{render} = require "react-dom"

# Components
App = require "./components/App.cjsx"
Index = require "./components/pages/Index.cjsx"
Room = require "./components/pages/Room.cjsx"
Rooms = require "./components/pages/Rooms.cjsx"

# Root
Root = React.createClass

    render: ->
        <Router history={browserHistory}>
            <Route path="/" component={App}>
                <IndexRoute component={Index} />
                <Route path="/rooms" component={Rooms} />
                <Route path="/rooms/:id" component={Room} />
            </Route>
        </Router>

# Render root
render <Root />, document.getElementById "root"
