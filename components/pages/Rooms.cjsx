React = require "react"
{Link} = require "react-router"
{Button, Table} = require "react-bootstrap"

Rooms = require "../../stores/RoomStore"

AddRoom = require "../dialogs/AddRoom"
DeleteRoom = require "../dialogs/DeleteRoom"

module.exports = React.createClass

    getInitialState: ->
        showAdd: false
        showDelete: false
        deleteId: null

    renderRoom: (key, room) ->
        url = "https://osu.ppy.sh/mp/" + room.id

        <tr key={key}>
            <td>{room.id}</td>
            <td>
                <a
                    href={url}
                    target="_blank"
                >
                    {url}
                </a>
            </td>
            <td>{room.data.match.name}</td>
            <td>
                <Link to={"/" + room.id}>Show</Link>
                &nbsp;
                <a href="#" onClick={@handleOnDelete room.id}>Delete</a>
            </td>
        </tr>

    renderRooms: ->
        rooms = []
        count = 0

        for room in Rooms.all()
            rooms.push @renderRoom count, room
            count++

        return rooms

    showAdd: ->
        @setState showAdd: true

    closeAdd: ->
        @setState showAdd: false

    closeDelete: ->
        @setState
            showDelete: false
            deleteId: null

    render: ->
        addButtonStyle =
            position: "fixed"
            left: "5px"
            bottom: "5px"

        <div className="panel panel-primary">
            <div className="panel-heading">
                <h3 className="panel-title">Rooms</h3>
            </div>
            <Table responsive bordered striped>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>URL</th>
                        <th>Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {@renderRooms()}
                </tbody>
            </Table>
            <AddRoom show={@state.showAdd} onHide={@closeAdd} />
            <DeleteRoom show={@state.showDelete} onHide={@closeDelete} id={@state.deleteId} />
            <Button style={addButtonStyle} bsStyle="primary" onClick={@showAdd}>Add</Button>
        </div>

    handleOnDelete: (id) -> (e) =>
        @setState
            showDelete: true
            deleteId: id
