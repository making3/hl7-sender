module ControlCharacters exposing (..)

import Char
import Hex
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import View.Layout.Modal as Layout exposing (view)


-- MODEL


type alias Model =
    { startOfText : Int
    , endOfText : Int
    , endOfLine : Int
    }


init : Model
init =
    { startOfText = 9
    , endOfText = 45
    , endOfLine = 35
    }



-- VIEW


view : Model -> Model -> Html Msg
view model existingModel =
    Layout.view "Settings - Control Characters" (viewForm model existingModel) Exit


viewForm : Model -> Model -> Html Msg
viewForm model existingModel =
    div []
        [ viewHeading
        , viewCharacters model existingModel
        ]


viewHeading : Html Msg
viewHeading =
    div []
        [ label [ class "settings-label-control-character" ] [ text "Control Character" ]
        , label [ class "settings-label-control-decimal" ] [ text "Decimal" ]
        , label [ class "settings-label-control-ascii" ] [ text "ASCII" ]
        , label [ class "settings-label-control-hex" ] [ text "Hex" ]
        ]


viewCharacters : Model -> Model -> Html Msg
viewCharacters model existingModel =
    let
        pendingUpdate =
            isPending model existingModel
    in
    div
        [ class "form" ]
        [ viewInput
            model.startOfText
            "Start of HL7"
            UpdateStartOfText
        , viewInput
            model.endOfText
            "End of HL7"
            UpdateEndOfText
        , viewInput
            model.endOfLine
            "End of Segment"
            UpdateEndOfLine
        , div [ class "settings-buttons" ]
            [ button
                [ class "btn btn-primary"
                , onClick SaveControlCharacters
                , disabled (pendingUpdate == False)
                ]
                [ text "Save" ]
            , button
                [ class "btn btn-primary"
                , onClick ResetControlCharacters
                , disabled (pendingUpdate == False)
                ]
                [ text "Reset" ]
            ]
        ]


viewInput : Int -> String -> (String -> Msg) -> Html Msg
viewInput controlCharacter labelText inputMsg =
    div [ class "control-character" ]
        [ label []
            [ text labelText ]
        , input
            [ class "form-control"
            , onInput inputMsg
            , value (Basics.toString controlCharacter)
            ]
            []
        , label [ class "settings-label-control-ascii" ] [ text (viewAsciiCharacter controlCharacter) ]
        , label [ class "settings-label-control-hex" ] [ text (viewHexCode controlCharacter) ]
        ]


viewAsciiCharacter : Int -> String
viewAsciiCharacter character =
    if character < 32 then
        "N/A"
    else
        Char.fromCode character
            |> Basics.toString
            |> printStr


printStr : String -> String
printStr str =
    if String.left 1 str == "'" then
        String.dropRight 1 (String.dropLeft 1 str)
    else
        str


viewHexCode : Int -> String
viewHexCode character =
    "0x" ++ Hex.toString character



-- UPDATE


type Msg
    = UpdateStartOfText String
    | UpdateEndOfText String
    | UpdateEndOfLine String
    | SaveControlCharacters
    | ResetControlCharacters
    | Exit


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ResetControlCharacters ->
            init ! []

        _ ->
            updateForm msg model ! []


updateForm : Msg -> Model -> Model
updateForm msg model =
    case msg of
        UpdateStartOfText newSot ->
            { model | startOfText = getInt newSot }

        UpdateEndOfText newEot ->
            { model | endOfText = getInt newEot }

        UpdateEndOfLine newEol ->
            { model | endOfLine = getInt newEol }

        _ ->
            model


isPending : Model -> Model -> Bool
isPending model existingModel =
    (model.startOfText /= existingModel.startOfText)
        || (model.endOfText /= existingModel.endOfText)
        || (model.endOfLine /= existingModel.endOfLine)


getInt : String -> Int
getInt str =
    -- TODO: Error handling (Err msg)
    case String.toInt str of
        Ok i ->
            i

        Err _ ->
            0
