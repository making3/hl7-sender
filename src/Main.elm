module Main exposing (..)

import About
import AddConnection
import Array exposing (Array, fromList)
import Char
import Connection
import ControlCharacters exposing (Msg)
import Dom.Scroll
import HL7
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (Decoder, decodeString, int)
import Json.Decode.Pipeline exposing (decode)
import Ports
import Ports.Connection
import Ports.Settings
import Settings
import Task
import Utilities


init : ( Model, Cmd Msg )
init =
    let
        model =
            initialModel
    in
    model
        ! [ Ports.loadVersion
          , Ports.Settings.get model.settings
          , Ports.Connection.get model.connection
          ]



-- MODEL


type Modal
    = None
    | ControlCharacters
    | AddConnection Connection.Connection
    | About


type alias Model =
    { hl7 : String
    , logs : List String
    , connection : ConnectionModel
    , settings : Settings.Model
    , modal : Modal
    , version : Maybe String
    }


type alias ConnectionModel =
    { destinationIp : String
    , destinationPort : Int
    , isConnected : Bool
    , connectionMessage : String
    , sentCount : Int
    , savedConnections : Array Connection
    , currentSavedConnectionName : String
    }


type alias Connection =
    { name : String
    , destinationIp : String
    , destinationPort : Int
    }


initialModel : Model
initialModel =
    { hl7 = ""
    , logs = []
    , connection = initialConnectionModel
    , settings = Settings.model
    , modal = None
    , version = Nothing
    }


initialConnectionModel : ConnectionModel
initialConnectionModel =
    { destinationIp = "127.0.0.1"
    , destinationPort = 1337
    , isConnected = False
    , connectionMessage = "Disconnected"
    , sentCount = 0
    , savedConnections = Array.fromList [ getDefaultConnection ]
    , currentSavedConnectionName = "Default"
    }


getDefaultConnection : Connection
getDefaultConnection =
    Connection "Default" "127.0.0.1" 1337


getLogId : String
getLogId =
    "logs"



-- VIEW


view : Model -> Html Msg
view model =
    case model.modal of
        ControlCharacters ->
            model.settings.controlCharacters
                |> ControlCharacters.view
                |> Html.map ControlCharactersMsg

        About ->
            let
                version =
                    case model.version of
                        Just v ->
                            v

                        Nothing ->
                            "N / A"
            in
            About.view version ExitModal

        AddConnection model ->
            model
                |> AddConnection.view
                |> Html.map AddConnectionMsg

        None ->
            viewPrimaryForm model


viewPrimaryForm : Model -> Html Msg
viewPrimaryForm model =
    div []
        [ viewHl7Form model
        , viewFooter model
        ]


viewHl7Form : Model -> Html Msg
viewHl7Form model =
    div [ class "simple-sender" ]
        [ label [] [ text "HL7 Message" ]
        , simpleSenderButtons model
        , textarea
            [ class "hl7 form-control"
            , onInput ChangeHl7
            , rows 8
            ]
            [ text model.hl7 ]
        ]


simpleSenderButtons : Model -> Html Msg
simpleSenderButtons model =
    div [ class "float-right" ]
        [ button
            [ class "validate btn btn-sm btn-primary"
            , disabled True
            ]
            [ text "Validate" ]
        , button
            [ class "btn btn-sm btn-primary"
            , onClick Send
            , disabled (model.connection.isConnected == False)
            ]
            [ text "Send" ]
        ]


viewFooter : Model -> Html Msg
viewFooter model =
    footer
        [ class "footer" ]
        [ connectionForm model
        , separator
        , viewStatus model
        ]


connectionForm : Model -> Html Msg
connectionForm model =
    div [ class "connection-row" ]
        [ div [ class "connection" ] [ viewConnectionForm model ]
        , div [ class "log" ] (viewLogs model)
        ]


separator : Html Msg
separator =
    hr [ class "connection-status-separator" ] []


viewStatus : Model -> Html Msg
viewStatus model =
    div [ class "status-row" ]
        [ label [ class "sent-count" ]
            [ text ("Sent Count: " ++ toString model.connection.sentCount) ]
        , label
            [ class ("connection-status " ++ getConnectionColor model.connection.isConnected) ]
            [ text model.connection.connectionMessage ]
        ]


getConnectionColor : Bool -> String
getConnectionColor isConnected =
    if isConnected then
        "connected"
    else
        "disconnected"


viewLogs : Model -> List (Html Msg)
viewLogs model =
    [ textarea
        [ id getLogId
        , readonly True
        , rows 5
        , class "form-control"
        ]
        [ text (getLogs model) ]
    ]


getLogs : Model -> String
getLogs model =
    List.reverse model.logs
        |> String.join "\n"


viewConnectionForm : Model -> Html Msg
viewConnectionForm model =
    div [ class "row" ]
        [ div [ class "col-8" ] (connectionFormControls model.connection)
        , div [ class "col-4" ] (connectionButtons model)
        ]


connectionFormControls : ConnectionModel -> List (Html Msg)
connectionFormControls connectionModel =
    [ formInput connectionModel "Saved" inputSavedConnections
    , formInput connectionModel "Host" inputIpAddress
    , formInput connectionModel "Port" inputPort
    ]


inputIpAddress : ConnectionModel -> Html Msg
inputIpAddress connectionModel =
    inputControl
        "Host"
        connectionModel.destinationIp
        connectionModel.isConnected
        ChangeDestinationIp


inputPort : ConnectionModel -> Html Msg
inputPort connectionModel =
    inputControl
        "Port"
        (Utilities.getPortDisplay connectionModel.destinationPort)
        connectionModel.isConnected
        ChangeDestinationPort


formInput : ConnectionModel -> String -> (ConnectionModel -> Html Msg) -> Html Msg
formInput connectionModel name inputControl =
    div
        [ class "form-group row connection-input-form" ]
        [ label
            [ class "col-sm-3 col-form-label col-form-label-sm" ]
            [ text name ]
        , div
            [ class "col-9" ]
            [ inputControl connectionModel ]
        ]


inputControl : String -> String -> Bool -> (String -> Msg) -> Html Msg
inputControl inputPlaceholder getValue isConnected msg =
    input
        [ class "form-control form-control-sm"
        , placeholder inputPlaceholder
        , readonly isConnected
        , onInput msg
        , value getValue
        ]
        []


inputSavedConnections : ConnectionModel -> Html Msg
inputSavedConnections connection =
    div []
        [ select
            [ id getSavedConnectionsId
            , class "form-control form-control-sm"
            , onInput ChangeSavedConnection
            , disabled connection.isConnected
            ]
            (Array.toList (Array.map toOptions (Array.push getCreateNewConnection connection.savedConnections)))
        ]


getCreateNewConnection : Connection
getCreateNewConnection =
    Connection "Create New" "127.0.0.1" 3000


getSavedConnectionsId : String
getSavedConnectionsId =
    "saved-connections"


toOptions : Connection -> Html msg
toOptions connection =
    option [ value connection.name ] [ text connection.name ]


connectionButtons : Model -> List (Html Msg)
connectionButtons model =
    [ button
        [ class "btn btn-sm btn-block btn-primary"
        , onClick ToggleConnection
        ]
        [ text (getConnectButtonText model.connection.isConnected) ]
    , button
        [ class "clear-log btn btn-sm btn-block btn-secondary"
        , onClick ClearLog
        ]
        [ text "Clear Log" ]
    , button
        [ class "save-connection btn btn-sm btn-block btn-secondary"
        , onClick SaveConnection
        ]
        [ text "Save" ]
    ]


getConnectButtonText : Bool -> String
getConnectButtonText isConnected =
    case isConnected of
        True ->
            "Disconnect"

        False ->
            "Connect"



-- UPDATE


type Msg
    = ChangeHl7 String
    | Version String
    | ChangeDestinationIp String
    | ChangeDestinationPort String
    | ToggleConnection
    | Connected
    | Disconnected
    | ConnectionError String
    | ClearLog
    | Send
    | Sent
    | MenuClick String
    | ExitModal
    | NoOp
    | InitialSettings ( String, String )
    | Saved String
    | ChangeSavedConnection String
    | ControlCharactersMsg ControlCharacters.Msg
    | AddConnectionMsg AddConnection.Msg
    | InitialSavedConnections ( String, String )
    | SavedNewConnection String
    | SaveConnection
    | SavedConnection String


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Saved errorMessage ->
            if errorMessage == "" then
                log "info" "Saved settings" model
            else
                log "error" errorMessage model

        ChangeHl7 hl7 ->
            ( updateHl7 model hl7, Cmd.none )

        Version version ->
            ( updateVersion model version, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        ChangeDestinationIp ipAddress ->
            ( updateIpAddress model ipAddress, Cmd.none )

        ChangeDestinationPort newPort ->
            ( changeDestinationPort model newPort, Cmd.none )

        ToggleConnection ->
            updateToggleConnection model

        Connected ->
            connected model
                |> log "info" "Connected"

        Disconnected ->
            disconnected model
                |> log "info" "Disconnected"

        ConnectionError errorMsg ->
            disconnected model
                |> log "error" errorMsg

        ClearLog ->
            ( { model | logs = [] }, Cmd.none )

        Send ->
            ( model, Ports.send (HL7.getWrappedHl7 model.settings.controlCharacters model.hl7) )

        Sent ->
            updateSentCount model
                |> log "info" "Sent a message"

        MenuClick menuItem ->
            menuClickOption menuItem model

        ExitModal ->
            { model | modal = None } ! []

        InitialSettings ( error, settingsJson ) ->
            case error of
                "" ->
                    case Settings.toModel settingsJson of
                        Ok settings ->
                            let
                                newControlCharacters =
                                    ControlCharacters.resetTempCharacters settings.controlCharacters

                                newSettings =
                                    { settings | controlCharacters = newControlCharacters }
                            in
                            ( { model | settings = newSettings }, Cmd.none )

                        Err errorMessage ->
                            log "error" errorMessage model

                errorMessage ->
                    log "error" errorMessage model

        ChangeSavedConnection connectionName ->
            changeConnectionFromSaved model connectionName ! []

        InitialSavedConnections ( "", savedConnectionsJson ) ->
            updateInitialSavedConnections model savedConnectionsJson

        InitialSavedConnections ( errorMessage, savedConnectionsJson ) ->
            log "error" errorMessage model

        SavedNewConnection "" ->
            model
                |> addNewConnection
                |> logSavedConnection

        SavedNewConnection errorMessage ->
            log "error" ("Failed to save message" ++ errorMessage) model

        SaveConnection ->
            let
                connection =
                    { name = model.connection.currentSavedConnectionName
                    , destinationIp = model.connection.destinationIp
                    , destinationPort = model.connection.destinationPort
                    }
            in
            ( model, Ports.Connection.saveConnection connection )

        SavedConnection "" ->
            -- TODO: For some reason this reset all names to "Default"
            model
                |> updateSavedConnectionsWithCurrent
                |> logSavedConnection

        SavedConnection errorMessage ->
            log "error" ("Failed to save message" ++ errorMessage) model

        _ ->
            updateModal msg model


addNewConnection : Model -> Model
addNewConnection model =
    let
        connection =
            model.connection

        settings =
            model.settings

        newIndividualConnection =
            getNewConnection model

        newConnection =
            { connection
                | savedConnections = appendConnectionToArray model newIndividualConnection model.connection.savedConnections
            }

        newSettings =
            { settings
                | newConnectionName = ""
            }

        newModel =
            { model
                | connection = newConnection
                , settings = newSettings
                , modal = None
            }
    in
    updateCurrentConnection newModel newIndividualConnection


appendConnectionToArray : Model -> Connection -> Array Connection -> Array Connection
appendConnectionToArray model newConnection connections =
    Array.push newConnection connections


getNewConnection : Model -> Connection
getNewConnection model =
    { name = model.settings.newConnectionName
    , destinationIp = model.connection.destinationIp
    , destinationPort = model.connection.destinationPort
    }


updateSavedConnectionsWithCurrent : Model -> Model
updateSavedConnectionsWithCurrent model =
    let
        connection =
            model.connection

        newSavedConnections =
            updateSavedConnectionsByIndex
                connection.savedConnections
                model.connection.currentSavedConnectionName
                model.connection.destinationIp
                model.connection.destinationPort

        newConnection =
            { connection | savedConnections = newSavedConnections }
    in
    { model | connection = newConnection }


updateSavedConnectionsByIndex : Array Connection -> String -> String -> Int -> Array Connection
updateSavedConnectionsByIndex connections connectionName destinationIp destinationPort =
    Array.set (Array.length connections - 1) { name = connectionName, destinationIp = destinationIp, destinationPort = destinationPort } connections


logSavedConnection : Model -> ( Model, Cmd Msg )
logSavedConnection model =
    log "info" "Saved Connection!" model


updateInitialSavedConnections : Model -> String -> ( Model, Cmd Msg )
updateInitialSavedConnections model savedConnectionsJson =
    case toSavedConnectionsModels savedConnectionsJson of
        Ok savedConnections ->
            let
                connection =
                    model.connection

                newConnection =
                    { connection | savedConnections = savedConnections }

                newModel =
                    { model | connection = newConnection }

                defaultConnectionName =
                    getInitialConnectionName savedConnections
            in
            ( changeConnectionFromSaved newModel defaultConnectionName, Cmd.none )

        Err errorMessage ->
            log "error" errorMessage model


changeConnectionFromSaved : Model -> String -> Model
changeConnectionFromSaved model connectionName =
    case connectionName of
        "Create New" ->
            { model | modal = AddConnection AddConnection.init }

        _ ->
            case findConnectionByName model connectionName of
                Nothing ->
                    model

                Just newConnection ->
                    updateCurrentConnection model newConnection


findConnectionByName : Model -> String -> Maybe Connection
findConnectionByName model connectionName =
    List.head (List.filter (\m -> m.name == connectionName) (Array.toList model.connection.savedConnections))


getInitialConnectionName : Array Connection -> String
getInitialConnectionName connections =
    case Array.get 0 connections of
        Just connection ->
            connection.name

        Nothing ->
            ""


updateCurrentConnection : Model -> Connection -> Model
updateCurrentConnection model newConnection =
    let
        connection =
            model.connection

        replacedConnection =
            { connection
                | destinationIp = newConnection.destinationIp
                , destinationPort = newConnection.destinationPort
                , currentSavedConnectionName = newConnection.name
            }
    in
    { model | connection = replacedConnection }


updateModal : Msg -> Model -> ( Model, Cmd Msg )
updateModal msg model =
    case ( msg, model.modal ) of
        ( ControlCharactersMsg subMsg, ControlCharacters ) ->
            let
                ( subModel, subCmd ) =
                    ControlCharacters.update subMsg model.settings.controlCharacters

                oldSettings =
                    model.settings

                newSettings =
                    { oldSettings | controlCharacters = subModel }

                newModel =
                    { model | settings = newSettings }
            in
            case subMsg of
                ControlCharacters.SaveControlCharacters ->
                    ( newModel, Ports.Settings.save newModel.settings )

                ControlCharacters.Exit ->
                    { newModel | modal = None } ! []

                _ ->
                    newModel ! []

        ( AddConnectionMsg subMsg, AddConnection subModel ) ->
            let
                ( newSubModel, subCmd ) =
                    AddConnection.update subMsg subModel

                newModal =
                    AddConnection newSubModel

                newModel =
                    { model | modal = newModal }
            in
            case subMsg of
                AddConnection.Exit ->
                    { model | modal = None } ! []

                AddConnection.SaveConnection ->
                    ( newModel, Ports.Connection.saveConnection newSubModel )

                _ ->
                    newModel ! []

        ( _, _ ) ->
            model ! []


updateIpAddress : Model -> String -> Model
updateIpAddress model ipAddress =
    let
        connection =
            model.connection

        newConnection =
            { connection | destinationIp = ipAddress }
    in
    { model | connection = newConnection }


changeDestinationPort : Model -> String -> Model
changeDestinationPort model newPort =
    case validatePort newPort of
        ValidPort validatedPort ->
            { model | connection = updatePort model.connection validatedPort }

        EmptyPort ->
            { model | connection = updatePort model.connection 0 }

        InvalidPort ->
            model


updatePort connection newPort =
    { connection | destinationPort = clamp 1 65535 newPort }


updateToggleConnection : Model -> ( Model, Cmd Msg )
updateToggleConnection model =
    case model.connection.isConnected of
        False ->
            ( model
            , Ports.connect
                ( model.connection.destinationIp
                , model.connection.destinationPort
                )
            )

        True ->
            ( model
            , Ports.disconnect ()
            )


connected model =
    { model
        | connection = updateConnectionStatus model.connection True "Connected"
    }


disconnected model =
    { model
        | connection = updateConnectionStatus model.connection False "Disconnected"
    }


updateConnectionStatus connection isConnected message =
    { connection
        | isConnected = isConnected
        , connectionMessage = message
    }


updateHl7 : Model -> String -> Model
updateHl7 model newHl7 =
    { model | hl7 = newHl7 }


updateVersion : Model -> String -> Model
updateVersion model version =
    { model | version = Just version }


log : String -> String -> Model -> ( Model, Cmd Msg )
log level message model =
    ( { model | logs = message :: model.logs }, scrollLogsToBottom )


scrollLogsToBottom : Cmd Msg
scrollLogsToBottom =
    Task.attempt (always NoOp) <| Dom.Scroll.toBottom getLogId


validateIp : String -> IpValidation
validateIp ip =
    ValidIp


validatePort : String -> PortValidation
validatePort portStr =
    if portStr == "" then
        EmptyPort
    else
        case String.toInt portStr of
            Ok newPort ->
                ValidPort newPort

            Err _ ->
                InvalidPort


updateSentCount : Model -> Model
updateSentCount model =
    let
        connection =
            model.connection

        newConnection =
            { connection | sentCount = connection.sentCount + 1 }
    in
    { model | connection = newConnection }


menuClickOption : String -> Model -> ( Model, Cmd Msg )
menuClickOption menuItem model =
    case menuItem of
        "about" ->
            { model | modal = About } ! []

        "edit-control-characters" ->
            { model | modal = ControlCharacters } ! []

        _ ->
            model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.menuClick MenuClick
        , Ports.settings InitialSettings
        , Ports.settingsSaved Saved
        , Ports.connected (always Connected)
        , Ports.disconnected (always Disconnected)
        , Ports.connectionError ConnectionError
        , Ports.sent (always Sent)
        , Ports.version Version
        , Ports.savedConnection SavedConnection
        , Ports.savedNewConnection SavedNewConnection
        , Ports.initialSavedConnections InitialSavedConnections
        ]



-- SERIALIZATION


toSavedConnectionsModels : String -> Result String (Array Connection)
toSavedConnectionsModels json =
    Decode.decodeString (Decode.array decodeConnection) json


decodeConnection : Decoder Connection
decodeConnection =
    decode Connection
        |> Json.Decode.Pipeline.required "name" Decode.string
        |> Json.Decode.Pipeline.required "destinationIp" Decode.string
        |> Json.Decode.Pipeline.required "destinationPort" Decode.int



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
