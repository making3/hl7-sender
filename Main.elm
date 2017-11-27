port module Main exposing (..)

import Html exposing (Html, Attribute, program, div, span, input, button, text, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { content : String
    , isConnected : Bool
    , connectionMessage : String
    , destinationIp : String
    , destinationPort : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" False "Disconnected" "127.0.0.1" 1337, Cmd.none )


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp


type Msg
    = Change String
    | ToggleConnection
    | Connected String
    | ConnectionError String
    | Disconnected String
    | ChangeDestinationIp String
    | ChangeDestinationPort String


port connect : ( String, Int ) -> Cmd msg


port disconnect : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newContent ->
            ( { model | content = newContent }, Cmd.none )

        ChangeDestinationIp newIp ->
            ( { model | destinationIp = newIp }, Cmd.none )

        ChangeDestinationPort newPort ->
            case validatePort newPort of
                ValidPort validatedPort ->
                    ( { model | destinationPort = clamp 1 65535 validatedPort }, Cmd.none )

                EmptyPort ->
                    ( { model | destinationPort = 0 }, Cmd.none )

                InvalidPort ->
                    ( model, Cmd.none )

        ToggleConnection ->
            case model.isConnected of
                False ->
                    ( { model | connectionMessage = "Connecting" }, connect ( model.destinationIp, model.destinationPort ) )

                True ->
                    ( { model | connectionMessage = "Disconnecting..." }, disconnect "" )

        Connected _ ->
            ( { model | isConnected = True, connectionMessage = "Connected" }, Cmd.none )

        ConnectionError errorMsg ->
            -- TODO: Write error somewhere..
            ( { model | isConnected = False, connectionMessage = ("Disconnected: " ++ errorMsg) }, Cmd.none )

        Disconnected _ ->
            ( { model | isConnected = False, connectionMessage = "Disconnected" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [] [ label [] [ text "HL7 Message" ] ]
                , Html.textarea [] []
                , input [ placeholder "Text to reverse", onInput Change ] []
                , div [] [ text (String.reverse model.content) ]
                ]
            , div [ class "row" ]
                [ input [ placeholder "IP Address", onInput ChangeDestinationIp, value model.destinationIp ] []
                , input [ placeholder "Port", onInput ChangeDestinationPort, value (getPortDisplay model.destinationPort) ] []
                , button [ class "btn btn-default", onClick ToggleConnection ] [ text (getConnectButtonText model.isConnected) ]
                ]
            ]
        , Html.footer [ class "footer" ]
            [ div [ class "container" ]
                [ span [] [ text model.connectionMessage ]
                ]
            ]
        ]



-- TODO: Validate port range (1-65535)


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


getPortDisplay : Int -> String
getPortDisplay destinationPort =
    if destinationPort == 0 then
        ""
    else
        toString destinationPort


getConnectButtonText : Bool -> String
getConnectButtonText isConnected =
    case isConnected of
        True ->
            "Disconnect"

        False ->
            "Connect"



-- SUBS
-- Since Elm doesn't allow functions without parameters, just use empty strings


port connected : (String -> msg) -> Sub msg


port connectionError : (String -> msg) -> Sub msg


port disconnected : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ connected Connected
        , connectionError ConnectionError
        , disconnected Disconnected
        ]
