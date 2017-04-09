import QtQuick 2.4
import QtMultimedia 5.0
import Ubuntu.Components 1.3

Item
{
    property alias source: mediaplayer.source

    id: animatedmessage

    MediaPlayer {
        id: mediaplayer
//        loops: MediaPlayer.Infinite
        autoPlay: false
    }

    Image {
        id: imgthumbnail
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        visible: !mediamessageitem.downloaded || mediaplayer.playbackState !== MediaPlayer.PlayingState
        source: "file://" + mediamessageitem.thumbnail
    }

    AbstractButton {
        anchors.fill: parent
        enabled: !mediamessageitem.downloaded || mediaplayer.playbackState !== MediaPlayer.PlayingState
        activeFocusOnPress: false
        onClicked: {
            if (mediamessageitem.downloaded) {
                mediaplayer.play();
            } else {
                mediamessageitem.download()
            }
        }
    }

    VideoOutput {
        anchors.fill: parent
        source: mediaplayer
        visible: mediamessageitem.downloaded
    }

    Icon {
        anchors.centerIn: parent
        width: units.gu(3)
        height: width
        color: "white"
        name: "media-preview-start"
        visible: !mediamessageitem.downloaded || mediaplayer.playbackState !== MediaPlayer.PlayingState
    }

    ActivityIndicator {
        anchors.centerIn: parent
        visible: mediamessageitem.downloading
        running: visible
    }
}
