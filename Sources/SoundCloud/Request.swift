//
//  SoundCloud Request.swift
//  SC Demo
//
//  Created by Ryan Forsyth on 2023-08-12.
//
// https://developers.soundcloud.com/docs/api/explorer/open-api#/

import Foundation

extension SoundCloud {
    
    struct Request<T: Decodable> {
        
        var api: API
        
        enum API {
            case accessToken(_ accessCode: String, _ clientId: String, _ clientSecret: String, _ redirectURI: String)
            case refreshAccessToken(_ refreshToken: String, _ clientId: String, _ clientSecret: String, _ redirectURI: String)
            case me
            case myLikedTracks
            case myFollowingsRecentlyPosted
            case myLikedPlaylists
            case myPlaylists
            case tracksForPlaylist(_ id: Int)
            case tracksForUser(_ id: Int, _ limit: Int = 20)
            case streamInfoForTrack(_ id: Int)
            case usersImFollowing
            
            case likeTrack(_ id: Int)
            case unlikeTrack(_ id: Int)
            
            case collectionForHref(_ href: String)
        }
        
        static func accessToken(_ code: String, _ clientId: String, _ clientSecret: String, _ redirectURI: String) -> Request<OAuthTokenResponse> {
            Request<OAuthTokenResponse>(api: .accessToken(code, clientId, clientSecret, redirectURI))
        }
        
        static func refreshToken(_ refreshToken: String, _ clientId: String, _ clientSecret: String, _ redirectURI: String) -> Request<OAuthTokenResponse> {
            Request<OAuthTokenResponse>(api: .refreshAccessToken(refreshToken, clientId, clientSecret, redirectURI))
        }
        
        static func me() -> Request<User> {
            Request<User>(api: .me)
        }
        
        static func myLikedTracks() -> Request<CollectionResponse<Track>> {
            Request<CollectionResponse<Track>>(api: .myLikedTracks)
        }
        
        static func myFollowingsRecentlyPosted() -> Request<[Track]> {
            Request<[Track]>(api: .myFollowingsRecentlyPosted)
        }
        
        static func myLikedPlaylists() -> Request<[Playlist]> {
            Request<[Playlist]>(api: .myLikedPlaylists)
        }
        
        static func myPlaylists() -> Request<[Playlist]> {
            Request<[Playlist]>(api: .myPlaylists)
        }
        
        static func tracksForPlaylist(_ id: Int) -> Request<[Track]> {
            Request<[Track]>(api: .tracksForPlaylist(id))
        }
        
        static func tracksForUser(_ id: Int, _ limit: Int = 20) -> Request<CollectionResponse<Track>> {
            Request<CollectionResponse<Track>>(api: .tracksForUser(id, limit))
        }
        
        static func streamInfoForTrack(_ id: Int) -> Request<StreamInfo> {
            Request<StreamInfo>(api: .streamInfoForTrack(id))
        }
        
        static func usersImFollowing() -> Request<CollectionResponse<User>> {
            Request<CollectionResponse<User>>(api: .usersImFollowing)
        }
        
        static func likeTrack(_ id: Int) -> Request<Status> {
            Request<Status>(api: .likeTrack(id))
        }
        
        static func unlikeTrack(_ id: Int) -> Request<Status> {
            Request<Status>(api: .unlikeTrack(id))
        }
        
        static func collectionForHref<U: Decodable>(_ href: String) -> Request<CollectionResponse<U>> {
            Request<CollectionResponse<U>>(api: .collectionForHref(href))
        }
    }
}

// MARK: - Request Parameters
extension SoundCloud.Request {
    
    var path: String {
        switch api {
        
        case .accessToken: return "oauth2/token"
        case .refreshAccessToken: return "oauth2/token"
        case .me: return "me"
        case .myLikedTracks: return "me/likes/tracks"
        case .myFollowingsRecentlyPosted: return "me/followings/tracks"
        case .myLikedPlaylists: return "me/likes/playlists"
        case .myPlaylists: return "me/playlists"
        case .tracksForPlaylist(let id): return "playlists/\(id)/tracks"
        case .tracksForUser(let id): return "users/\(id)/tracks"
        case .streamInfoForTrack(let id): return "tracks/\(id)/streams"
        case .usersImFollowing: return "me/followings"
            
        case .likeTrack(let id), .unlikeTrack(let id): return "likes/tracks/\(id)"
            
        case .collectionForHref(let href): return href
        }
    }
    
    var queryParameters: [String : String]? {
        switch api {

        case let .accessToken(accessCode, clientId, clientSecret, redirectURI): return [
            "code" : accessCode,
            "grant_type" : "authorization_code",
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "redirect_uri" : redirectURI
        ]
            
        case let .refreshAccessToken(refreshToken, clientId, clientSecret, redirectURI): return [
            "refresh_token" : refreshToken,
            "grant_type" : "refresh_token",
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "redirect_uri" : redirectURI
        ]
            
        case .myLikedTracks: return [
            "limit" : "20", // Page size
            "access" : "playable",
            "linked_partitioning" : "true"
        ]
            
        case .tracksForPlaylist: return [
            "access" : "playable"
        ]
            
        case .tracksForUser: return [
            "access" : "playable",
            "limit" : "20",
            "linked_partitioning" : "true"
        ]
            
        case .usersImFollowing: return [
            "limit" : "20", // Page size
            "linked_partitioning" : "true"
        ]
            
        default: return nil
        }
    }
    
    var httpMethod: String {
        switch api {

        case .accessToken,
             .refreshAccessToken,
             .likeTrack:
            return "POST"
        
        case .unlikeTrack: return "DELETE"
        
        default: return "GET"
        }
    }
}

// MARK: - Helpers
extension SoundCloud.Request {
    var shouldUseAuthHeader: Bool {
        switch api {
        case .accessToken, .refreshAccessToken: return false
        default: return true
        }
    }
    
    var isToRefresh: Bool {
        switch api {
            case .refreshAccessToken: return true
            default: return false
        }
    }
    
    var isForHref: Bool {
        switch api {
            case .collectionForHref: return true
            default: return false
        }
    }
}
