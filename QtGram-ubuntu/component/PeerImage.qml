import QtQuick 2.4
import QtGraphicalEffects 1.0
import LibQTelegram 1.0
import Ubuntu.Components 1.3

PeerView
{
    property color backgroundColor: UbuntuColors.graphite
    property color foregroundColor: "white"

    id: peerimage

    delegate: UbuntuShape {
        id: delegateitem
        anchors.fill: parent
        backgroundColor: peerimage.backgroundColor

        aspect: UbuntuShape.Flat

        source: Image {
            id: image
            anchors.fill: parent
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: "file://" + peerimage.source
        }

        Label {
            id: fallbacktext
            font.bold: true
            fontSize: "large"
            text: peerimage.fallbackText
            anchors.centerIn: parent
            color: peerimage.foregroundColor
            visible: !peerimage.hasThumbnail
        }
    }
}
