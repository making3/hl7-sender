port module Update exposing (..)

import Msgs exposing (..)
import Models exposing (Model, Route(..), ControlCharacters)
import Validations exposing (..)
import Char


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
            ( model, send (getWrappedHl7 model) )

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

        MenuClick menuItem ->
            case menuItem of
                "edit-control-characters" ->
                    ( { model | route = RouteControlCharacters }, Cmd.none )

                _ ->
                    ( { model | route = RouteHome }, Cmd.none )

        -- SaveControlCharacters ->
        --     ( { model | controlCharacters = model.ControlCharacters, route = RouteHome }, Cmd.none )
        GoHome ->
            ( { model | route = RouteHome }, Cmd.none )

        UpdateStartOfText newSot ->
            let
                oldChars =
                    model.controlCharacters

                newChars =
                    { oldChars | startOfText = getInt newSot }
            in
                ( { model | controlCharacters = newChars }, Cmd.none )

        UpdateEndOfText newEot ->
            let
                oldChars =
                    model.controlCharacters

                newChars =
                    { oldChars | endOfText = getInt newEot }
            in
                ( { model | controlCharacters = newChars }, Cmd.none )

        UpdateEndOfLine newEol ->
            let
                oldChars =
                    model.controlCharacters

                newChars =
                    { oldChars | endOfLine = getInt newEol }
            in
                ( { model | controlCharacters = newChars }, Cmd.none )


getInt : String -> Int
getInt str =
    -- TODO: Error handling (Err msg)
    case String.toInt str of
        Ok i ->
            i

        Err _ ->
            0


getWrappedHl7 : Model -> String
getWrappedHl7 model =
    getCharStr model.controlCharacters.startOfText
        ++ model.hl7
        ++ getCharStr model.controlCharacters.endOfLine
        ++ getCharStr model.controlCharacters.endOfText


getCharStr : Int -> String
getCharStr i =
    String.fromChar (Char.fromCode i)
