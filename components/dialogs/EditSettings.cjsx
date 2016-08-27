React = require "react"
{Button, ControlLabel, FormGroup, FormControl, HelpBlock, Modal} = require "react-bootstrap"

Settings = require "../../stores/SettingStore"

# Edit settings dialog
module.exports = React.createClass

    # Initial state
    getInitialState: ->
        # osu! api key
        apiKey: ""

    # Validation state
    getValidationState: ->
        if @state.apiKey isnt "" then "success"

    componentWillMount: ->
        @setState apiKey: Settings.getApiKey() or ""

    # Render the dialog
    render: ->
        <Modal show={@props.show} onHide={@props.onHide}>
            <Modal.Header closeButton>
                <Modal.Title>Edit settings</Modal.Title>
            </Modal.Header>
            <form onSubmit={@handleSubmit}>
                <Modal.Body>
                    <FormGroup validationState={@getValidationState()}>
                        <ControlLabel>osu!api key</ControlLabel>
                        <FormControl
                            type="text"
                            value={@state.apiKey}
                            placeholder="osu!api key"
                            onChange={@handleChange}
                        />
                        <FormControl.Feedback />
                        <HelpBlock>
                            Your osu!api key. You can get one&nbsp;
                            <a href="https://osu.ppy.sh/p/api" target="_blank">here</a>
                        </HelpBlock>
                    </FormGroup>
                </Modal.Body>
                <Modal.Footer>
                    <Button onClick={@props.onHide}>Close</Button>
                    <Button type="submit" bsStyle="primary">Save</Button>
                </Modal.Footer>
            </form>
        </Modal>

    handleSubmit: (e) ->
        e.preventDefault()
        Settings.setApiKey @state.apiKey
        @props.onHide()

    # Called when the input has changed
    handleChange: (e) ->
        @setState apiKey: e.target.value
