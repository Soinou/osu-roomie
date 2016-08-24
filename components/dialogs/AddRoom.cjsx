React = require "react"
{Button, ControlLabel, FormGroup, FormControl, HelpBlock, Modal} = require "react-bootstrap"

Rooms = require "../../stores/RoomStore"

# osu! mp link pattern
urlPattern = /^https?:\/\/osu.ppy.sh\/mp\/(\d+)$/

# Dialog to add a new room
module.exports = React.createClass

    # Initial state (Empty URL)
    getInitialState: -> url: "", error: null

    # Validation state
    getValidationState: ->

        if @state.error?
            "error"
        # Test the url against the mp link pattern
        else if @state.url isnt ""
            match = urlPattern.exec @state.url
            if match? then "success" else "error"

    help: ->
        if @state.error?
            @state.error.toString()
        else
            "Example url: https://osu.ppy.sh/mp/133742"

    # Renders the dialog
    render: ->
        <Modal show={@props.show} onHide={@handleHide}>
            <Modal.Header closeButton>
                <Modal.Title>Add a room</Modal.Title>
            </Modal.Header>
            <form onSubmit={@handleSubmit}>
                <Modal.Body>
                    <FormGroup validationState={@getValidationState()}>
                        <ControlLabel>Room URL</ControlLabel>
                        <FormControl
                            type="text"
                            value={@state.url}
                            placeholder="Room URL"
                            onChange={@handleChange}
                        />
                        <FormControl.Feedback />
                        <HelpBlock>{@help()}</HelpBlock>
                    </FormGroup>
                </Modal.Body>
                <Modal.Footer>
                    <Button onClick={@handleHide}>Close</Button>
                    <Button type="submit" bsStyle="primary">Add</Button>
                </Modal.Footer>
            </form>
        </Modal>

    # Called when the dialog is hidden
    handleHide: ->
        @setState url: ""
        @props.onHide()

    # Called when the form is submitted
    handleSubmit: (e) ->
        e.preventDefault()
        match = urlPattern.exec @state.url
        if match?
            id = match[1]
            Rooms.add id, @state.url
            .then () =>
                @setState url: ""
                @props.onHide()
            .catch (error) =>
                @setState error: error

    # Called when the url input has changed
    handleChange: (e) ->
        @setState
            url: e.target.value
            error: null
