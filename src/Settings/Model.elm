module Settings.Model exposing (..)

import Connection.Model as Connection
import Settings.ControlCharacters.Model as ControlCharacters


type alias Model =
    { controlCharacters : ControlCharacters.Model
    }


model : Model
model =
    { controlCharacters = ControlCharacters.model
    }
