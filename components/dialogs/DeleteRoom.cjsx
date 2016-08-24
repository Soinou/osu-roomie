React = require "react"
{Button, Modal} = require "react-bootstrap"

Rooms = require "../../stores/RoomStore"

# Dialogs to add a new room
module.exports = React.createClass

    # Renders the dialog
    render: ->
        <Modal show={@props.show} onHide={@props.onHide}>
            <Modal.Header closeButton>
                <Modal.Title>Delete a room</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <p>Are you sure you want to delete this room? This action is not reversible.</p>
            </Modal.Body>
            <Modal.Footer>
                <Button onClick={@props.onHide}>No</Button>
                <Button bsStyle="primary" onClick={@deleteRoom}>Yes</Button>
            </Modal.Footer>
        </Modal>

    # Called when the yes button is pressed
    deleteRoom: ->
        Rooms.delete @props.id
        @props.onHide()
