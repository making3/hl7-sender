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
    , pendingUpdate : Bool
    , tempStartOfText : Int
    , tempEndOfText : Int
    , tempEndOfLine : Int
    }


initialModel : Model
initialModel =
    { startOfText = 9
    , endOfText = 45
    , endOfLine = 35
    , pendingUpdate = False
    , tempStartOfText = 9
    , tempEndOfText = 45
    , tempEndOfLine = 35
    }



-- VIEW


view : Model -> Html Msg
view model =
    Layout.view "Settings - Control Characters" (viewForm model) Exit


viewForm : Model -> Html Msg
viewForm model =
    div []
        [ viewHeading
        , viewCharacters model
        ]


viewHeading : Html Msg
viewHeading =
    div []
        [ label [ class "settings-label-control-character" ] [ text "Control Character" ]
        , label [ class "settings-label-control-decimal" ] [ text "Decimal" ]
        , label [ class "settings-label-control-ascii" ] [ text "ASCII" ]
        , label [ class "settings-label-control-hex" ] [ text "Hex" ]
        ]


viewCharacters : Model -> Html Msg
viewCharacters model =
    div
        [ class "form" ]
        [ viewInput
            model.tempStartOfText
            "Start of HL7"
            UpdateStartOfText
        , viewInput
            model.tempEndOfText
            "End of HL7"
            UpdateEndOfText
        , viewInput
            model.tempEndOfLine
            "End of Segment"
            UpdateEndOfLine
        , div [ class "settings-buttons" ]
            [ button
                [ class "btn btn-primary"
                , onClick SaveControlCharacters
                , disabled (model.pendingUpdate == False)
                ]
                [ text "Save" ]
            , button
                [ class "btn btn-primary"
                , onClick ResetControlCharacters
                , disabled (model.pendingUpdate == False)
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
        SaveControlCharacters ->
            saveControlCharacters model ! []

        ResetControlCharacters ->
            resetTempCharacters model ! []

        _ ->
            updateForm msg model ! []


resetTempCharacters : Model -> Model
resetTempCharacters model =
    { model
        | tempStartOfText = model.startOfText
        , tempEndOfText = model.endOfText
        , tempEndOfLine = model.endOfLine
        , pendingUpdate = False
    }


updateForm : Msg -> Model -> Model
updateForm msg model =
    case msg of
        UpdateStartOfText newSot ->
            { model | tempStartOfText = getInt newSot } |> isPending

        UpdateEndOfText newEot ->
            { model | tempEndOfText = getInt newEot } |> isPending

        UpdateEndOfLine newEol ->
            { model | tempEndOfLine = getInt newEol } |> isPending

        _ ->
            model


isPending : Model -> Model
isPending model =
    let
        isPendingUpdate =
            (model.tempStartOfText /= model.startOfText)
                || (model.tempEndOfText /= model.endOfText)
                || (model.tempEndOfLine /= model.endOfLine)
    in
    { model | pendingUpdate = isPendingUpdate }


saveControlCharacters : Model -> Model
saveControlCharacters model =
    { model
        | startOfText = model.tempStartOfText
        , endOfText = model.tempEndOfText
        , endOfLine = model.tempEndOfLine
        , pendingUpdate = False
    }


getInt : String -> Int
getInt str =
    -- TODO: Error handling (Err msg)
    case String.toInt str of
        Ok i ->
            i

        Err _ ->
            0
