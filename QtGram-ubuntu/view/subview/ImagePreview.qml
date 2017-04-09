import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

Page {
    id: root
    clip: true

    property string source
    property string from

    header: PageHeader {
        title: i18n.tr("From: %1").arg(root.from)
        trailingActionBar.actions: [
            Action {
                iconName: "share"
                onTriggered: apl.addPageToNextColumn(root, Qt.resolvedUrl("ContentHubPage.qml"), {handler: ContentHandler.Share, contentType: ContentType.Pictures, source: root.source })
            },
            Action {
                iconName: "document-open"
                onTriggered: apl.addPageToNextColumn(root, Qt.resolvedUrl("ContentHubPage.qml"), { handler: ContentHandler.Destination, contentType: ContentType.Pictures, source: root.source })
            }
        ]
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentHeight: height
        contentWidth: width

        PinchArea {
            id: pinchy
            width: Math.max(flick.contentWidth, flick.width)
            height: Math.max(flick.contentHeight, flick.height)

            property real initialWidth
            property real initialHeight
            onPinchStarted: {
                initialWidth = flick.contentWidth
                initialHeight = flick.contentHeight
            }

            onPinchUpdated: {
                // adjust content pos due to drag
                flick.contentX += pinch.previousCenter.x - pinch.center.x
                flick.contentY += pinch.previousCenter.y - pinch.center.y

                // resize content
                var maximumWidth = root.width * 2
                var maximumHeight = root.height * 2
                var newWidth = Math.max(root.width, Math.min(maximumWidth, initialWidth * pinch.scale))
                var newHeight = Math.max(root.height, Math.min(maximumHeight, initialHeight * pinch.scale))
                flick.resizeContent(newWidth, newHeight, pinch.center)
            }

            Rectangle {
                width: flick.contentWidth
                height: flick.contentHeight
                color: "white"

                Behavior on width { enabled: !pinchy.pinch.active; UbuntuNumberAnimation {} }
                Behavior on height { enabled: !pinchy.pinch.active; UbuntuNumberAnimation {} }

                Image {
                    anchors.fill: parent
                    source: root.source
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        anchors.fill: parent
                        onDoubleClicked: {
                            if (flick.contentWidth != root.width) {
                                flick.contentWidth = root.width
                                flick.contentHeight = root.height
                            } else {
                                flick.contentWidth = root.width * 2
                                flick.contentHeight = root.height * 2
                            }
                        }
                    }
                }
            }
        }
    }
}
