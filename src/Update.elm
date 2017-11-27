port module Update exposing (..)

import Msgs exposing (..)
import Models exposing (Model)
import Validations exposing (..)


port connect : ( String, Int ) -> Cmd msg


port disconnect : String -> Cmd msg


port send : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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

        ChangeHl7 newHl7 ->
            ( { model | hl7 = newHl7 }, Cmd.none )

        Send ->
            ( model, send model.hl7 )

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
