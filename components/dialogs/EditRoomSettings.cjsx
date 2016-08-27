React = require "react"
{Button, ControlLabel, FormGroup, FormControl, InputGroup, Modal} = require "react-bootstrap"

Rooms = require "../../stores/RoomStore"

module.exports = React.createClass

    getInitialState: ->
        pointsTable: null

    componentWillMount: ->
        @setState pointsTable: @props.room.settings.pointsTable

    isNumeric: (o) ->
        return !isNaN(o - parseFloat(o));

    getValidationState: (id) ->
        value = @state.pointsTable[id]
        if !@isNumeric @state.pointsTable[id]
            return "error"

    renderPoints: ->
        if not @state.pointsTable
            <p>...</p>
        else
            points = []
            count = 0

            for id, rank of @state.pointsTable
                points.push <FormGroup key={count} validationState={@getValidationState(id)}>
                    <ControlLabel>Rank #{id + 1}</ControlLabel>
                    <InputGroup>
                        <FormControl
                            type="text"
                            value={rank}
                            placeholder={"Rank #" + (id + 1)}
                            onChange={@handleChange(id)}
                        />
                        <InputGroup.Button>
                            <Button onClick={@delete(id)}>
                                <i className="fa fa-trash" style={{color: "red"}}></i>
                            </Button>
                        </InputGroup.Button>
                    </InputGroup>
                </FormGroup>
                count++

            return points

    # Render the dialog
    render: ->
        <Modal show={@props.show} onHide={@props.onHide}>
            <Modal.Header closeButton>
                <Modal.Title>Room settings</Modal.Title>
            </Modal.Header>
            <form>
                <Modal.Body>
                    {@renderPoints()}
                    <Button bsStyle="primary" onClick={@add}>
                        <i className="fa fa-plus"></i>
                    </Button>
                </Modal.Body>
                <Modal.Footer>
                    <Button onClick={@props.onHide}>Close</Button>
                    <Button bsStyle="primary" onClick={@props.onHide}>Done</Button>
                </Modal.Footer>
            </form>
        </Modal>

    # Called when the input has changed
    handleChange: (id) -> (e) =>
        table = @state.pointsTable
        table[id] = e.target.value
        @setState pointsTable: table

        # Save values only when they're valid
        if @isNumeric table[id]
            Rooms.updatePointsTable @props.room.id, table

    add: (e) ->
        table = @state.pointsTable
        table.push 0
        Rooms.updatePointsTable @props.room.id, table
        @setState pointsTable: table

    delete: (id) -> (e) =>
        table = @state.pointsTable
        table.splice id, 1
        Rooms.updatePointsTable @props.room.id, table
        @setState pointsTable: table
