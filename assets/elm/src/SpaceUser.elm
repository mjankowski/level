module SpaceUser exposing (Role(..), SpaceUser, avatar, decoder, displayName, firstName, fragment, id, lastName, roleDecoder, spaceId, userId)

import Avatar
import GraphQL exposing (Fragment)
import Html exposing (Html)
import Id exposing (Id)
import Json.Decode as Decode exposing (Decoder, fail, field, int, maybe, string, succeed)
import Json.Decode.Pipeline as Pipeline exposing (required)



-- TYPES


type SpaceUser
    = SpaceUser Data


type alias Data =
    { id : Id
    , userId : Id
    , spaceId : Id
    , firstName : String
    , lastName : String
    , handle : String
    , role : Role
    , avatarUrl : Maybe String
    , fetchedAt : Int
    }


type Role
    = Member
    | Owner


fragment : Fragment
fragment =
    GraphQL.toFragment
        """
        fragment SpaceUserFields on SpaceUser {
          id
          userId
          space {
            id
          }
          firstName
          lastName
          handle
          role
          avatarUrl
          fetchedAt
        }
        """
        []



-- ACCESSORS


id : SpaceUser -> Id
id (SpaceUser data) =
    data.id


userId : SpaceUser -> Id
userId (SpaceUser data) =
    data.userId


spaceId : SpaceUser -> Id
spaceId (SpaceUser data) =
    data.spaceId


firstName : SpaceUser -> String
firstName (SpaceUser data) =
    data.firstName


lastName : SpaceUser -> String
lastName (SpaceUser data) =
    data.lastName


displayName : SpaceUser -> String
displayName (SpaceUser data) =
    data.firstName ++ " " ++ data.lastName


avatar : Avatar.Size -> SpaceUser -> Html msg
avatar size (SpaceUser data) =
    Avatar.personAvatar size data



-- DECODERS


roleDecoder : Decoder Role
roleDecoder =
    let
        convert : String -> Decoder Role
        convert raw =
            case raw of
                "MEMBER" ->
                    succeed Member

                "OWNER" ->
                    succeed Owner

                _ ->
                    fail "Role not valid"
    in
    Decode.andThen convert string


decoder : Decoder SpaceUser
decoder =
    Decode.map SpaceUser
        (Decode.succeed Data
            |> required "id" Id.decoder
            |> required "userId" Id.decoder
            |> required "space" (field "id" Id.decoder)
            |> required "firstName" string
            |> required "lastName" string
            |> required "handle" string
            |> required "role" roleDecoder
            |> required "avatarUrl" (maybe string)
            |> required "fetchedAt" int
        )
