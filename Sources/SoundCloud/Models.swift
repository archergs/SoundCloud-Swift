//
//  SoundCloudAPI Models.swift
//  SC Demo
//
//  Created by Ryan Forsyth on 2023-08-11.
//

import Foundation
import SwiftUI



internal struct StreamInfo: Decodable {
    public let httpMp3128Url: String
    public let hlsMp3128Url: String
}

internal struct Status: Decodable {
    public let status: String
}

// MARK: - Test objects
public func testUser() -> User {
    User(
        avatarUrl: "https://i1.sndcdn.com/avatars-0DxRBnyCNCI3zL1X-oeoRyw-large.jpg",
        id: Int.random(in: 0..<1000),
        permalinkUrl: "https://i1.sndcdn.com/avatars-0DxRBnyCNCI3zL1X-oeoRyw-large.jpg",
        uri: "",
        username: "Rinse FM",
        createdAt: "",
        firstName: "",
        lastName: "",
        fullName: "",
        city: "",
        country: "",
        description: "",
        trackCount: 0,
        repostsCount: 0,
        followersCount: 0,
        followingsCount: 0,
        commentsCount: 0,
        online: false,
        likesCount: 0,
        playlistCount: 0,
        subscriptions: [testFreeSubscription]
    )
}

public func testPlaylist(empty: Bool) -> Playlist {
    Playlist (
        id: 1587600994,
        genre: "",
        permalink: "",
        permalinkUrl: "https://google.com",
        description: nil,
        uri: "",
        tagList: "",
        trackCount: 7,
        lastModified: "023/08/10 20:27:42 +0000",
        license: "",
        user: testUser(),
        likesCount: 20,
        sharing: "",
        createdAt: "2023/03/20 17:08:42 +0000",
        tags: "",
        kind: "",
        title: "RIZ LA TEEF on Rinse FM",
        streamable: true,
        artworkUrl: testTrack().artworkUrl,
        tracksUri: "https://api.soundcloud.com/playlists/1587600994/tracks",
        tracks: empty ? [] : [testTrack(), testTrack(), testTrack(), testTrack(), testTrack()]
    )
}

public func testTrack() -> Track {
    Track(
        id: Int.random(in: 0..<1000),
        createdAt: "2023/08/08 08:24:13 +0000",
        duration: 3678067,
        commentCount: 0,
        sharing: "public",
        tagList: "FrazerRay RinseFM Breakbeat Garage Bass",
        streamable: true,
        genre: "",
        title: "Frazer Ray - 07 August 2023",
        description: "",
        license: "",
        uri: "https://api.soundcloud.com/tracks/1586682955",
        user: testUser(),
        permalinkUrl: "https://soundcloud.com",
        artworkUrl: "https://i1.sndcdn.com/artworks-5Ahdjl0532u9N1a2-zoAq3w-large.jpg",
        streamUrl: "https://api.soundcloud.com/tracks/1586682955/stream",
        downloadUrl: "",
        waveformUrl: "https://wave.sndcdn.com/ycxIIzLADTvQ_m.png",
        availableCountryCodes: "",
        userFavorite: false,
        userPlaybackCount: 0,
        playbackCount: 0,
        favoritingsCount: 0,
        repostsCount: 0,
        access: "playable"
    )
}

public func testTrackBinding() -> Binding<Track> {
    var track = testTrack()
    return Binding(get: { track }, set: { newTrack in track = newTrack })
}

public var testDefaultLoadedPlaylists: [Int : Playlist] {
    var loadedPlaylists = [Int : Playlist]()
    let user = testUser()
    loadedPlaylists[PlaylistType.nowPlaying.rawValue] = Playlist(id: PlaylistType.nowPlaying.rawValue, user: user, title: PlaylistType.nowPlaying.title, tracks: [])
    loadedPlaylists[PlaylistType.downloads.rawValue] = Playlist(id: PlaylistType.downloads.rawValue, user: user, title: PlaylistType.downloads.title, tracks: [])
    loadedPlaylists[PlaylistType.likes.rawValue] = Playlist(id: PlaylistType.likes.rawValue, permalinkUrl: user.permalinkUrl + "/likes", user: user, title: PlaylistType.likes.title, tracks: [])
    loadedPlaylists[PlaylistType.recentlyPosted.rawValue] = Playlist(id: PlaylistType.recentlyPosted.rawValue, permalinkUrl: user.permalinkUrl + "/following", user: user, title: PlaylistType.recentlyPosted.title, tracks: [])
    return loadedPlaylists
}

public let testFreeSubscription = User.Subscription(product: User.Subscription.Product(id: "free", name: "Free"))

@MainActor
public var testSC = SoundCloud(SoundCloudConfig(apiURL: "", clientId: "", clientSecret: "", redirectURI: ""))

public var testSCConfig = SoundCloudConfig(apiURL: "", clientId: "", clientSecret: "", redirectURI: "")
