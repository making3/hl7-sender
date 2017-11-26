module Main exposing (..)

import Html exposing (Html, Attribute, div, span, input, button, text, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


main =
    Html.beginnerProgram { model = model, view = view, update = update }


type alias Model =
    { content : String
    , status : String
    , destinationIp : String
    , destinationPort : Int
    }


model : Model
model =
    { content = ""
    , status = "Disconnected"
    , destinationIp = ""
    , destinationPort = 0
    }


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type Msg
    = Change String
    | Connect
    | ChangeDestinationIp String
    | ChangeDestinationPort String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = newContent }

        ChangeDestinationIp newIp ->
            { model | destinationIp = "nopelol" }

        ChangeDestinationPort newPort ->
            case getValidPort newPort of
                ValidPort validatedPort ->
                    { model | destinationPort = clamp 1 65535 validatedPort }

                EmptyPort ->
                    { model | destinationPort = 0 }

                InvalidPort ->
                    model

        Connect ->
            { model | status = "Connected to " ++ (toString model.destinationPort) }


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
                [ input [ placeholder "IP Address", onInput ChangeDestinationIp ] [ text model.destinationIp ]
                , input [ placeholder "Port", onInput ChangeDestinationPort, value (getPort model.destinationPort) ] []
                , button [ class "btn btn-default", onClick Connect ] [ text "Connect" ]
                ]
            ]
        , Html.footer [ class "footer" ]
            [ div [ class "container" ]
                [ span [] [ text model.status ]
                ]
            ]
        ]



-- TODO: Validate port range (1-65535)


getValidPort : String -> PortValidation
getValidPort portStr =
    if portStr == "" then
        EmptyPort
    else
        case String.toInt portStr of
            Ok newPort ->
                ValidPort newPort

            Err _ ->
                InvalidPort


getPort : Int -> String
getPort destinationPort =
    if destinationPort == 0 then
        ""
    else
        toString destinationPort
