React = require "react"
{Link} = require "react-router"
{LinkContainer} = require "react-router-bootstrap"
{Navbar, Nav, NavItem} = require "react-bootstrap"

EditSettings = require "./dialogs/EditSettings"

module.exports = React.createClass

    getInitialState: -> showSettings: false

    render: ->
        <div>
            <Navbar fluid inverse>
                <Navbar.Header>
                    <Navbar.Brand>
                        <Link to="/">osu!roomie</Link>
                    </Navbar.Brand>
                    <Navbar.Toggle />
                </Navbar.Header>
                <Navbar.Collapse>
                    <Nav pullRight>
                        <NavItem onClick={@showSettings}>Settings</NavItem>
                    </Nav>
                </Navbar.Collapse>
            </Navbar>
            <div className="container">
                {this.props.children}
            </div>
            <EditSettings show={@state.showSettings} onHide={@handleOnHide} />
        </div>

    showSettings: ->
        @setState showSettings: true

    handleOnHide: ->
        @setState showSettings: false
