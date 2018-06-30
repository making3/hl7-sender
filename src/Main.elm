module Main exposing (..)

import Connection
import Dom.Scroll
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task


init : ( Model, Cmd Msg )
init =
    model ! []



--, Commands.init initialModel )
-- MODEL


type alias Model =
    { hl7 : String
    , version : String
    , logs : List String

    -- , route : Route.Model
    , connection : Connection.Model

    -- , settings : Settings.Model
    }


model : Model
model =
    { hl7 = ""
    , version = "N/A"
    , logs = []

    -- , route = Route.model
    , connection = Connection.model

    -- , settings = Settings.model
    }


getLogId : String
getLogId =
    "logs"



-- VIEW


view : Model -> Html Msg
view model =
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

            -- , onClick (MsgForConnection Send)
            , disabled (model.connection.isConnected == False)
            ]
            [ text "Send" ]
        ]


viewFooter : Model -> Html Msg
viewFooter model =
    footer
        [ class "footer" ]
        [ --connectionForm model
          separator
        , viewStatus model
        ]


connectionForm : Model -> Html Msg
connectionForm model =
    div [ class "connection-row" ]
        [ div [ class "connection" ] [] --Connection.view model ]
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



-- UPDATE


type Msg
    = ChangeHl7 String
    | Version String
      -- | MsgForRoute Route.Msg
      -- | MsgForSettings Settings.Msg
      -- | MsgForConnection Connection.Msg
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeHl7 hl7 ->
            ( updateHl7 model hl7, Cmd.none )

        Version version ->
            ( updateVersion model version, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


updateHl7 : Model -> String -> Model
updateHl7 model newHl7 =
    { model | hl7 = newHl7 }


updateVersion : Model -> String -> Model
updateVersion model version =
    { model | version = version }


log : String -> String -> Model -> ( Model, Cmd Msg )
log level message model =
    ( { model | logs = message :: model.logs }, scrollLogsToBottom )


scrollLogsToBottom : Cmd Msg
scrollLogsToBottom =
    Task.attempt (always NoOp) <| Dom.Scroll.toBottom getLogId



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none -- Subs.init
        }
