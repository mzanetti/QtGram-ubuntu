import QtQuick 2.4
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3

Item
{
    property alias source: image.source
    property bool needsBlur: false

    id: imagemessage

    signal openImage()

    Component.onCompleted: {
        if (!mediamessageitem.downloaded) {
            mediamessageitem.download();
        }
    }


    Image
    {
        id: image
        anchors.fill: parent
        asynchronous: true
    }

    FastBlur
    {
        anchors.fill: image
        source: image
        radius: needsBlur ? 32.0 : 0.0
    }

    ActivityIndicator { z: 2; anchors.centerIn: parent; running: mediamessageitem.downloading }
    MouseArea {
        anchors.fill: parent;
        onClicked: {
            if (!mediamessageitem.downloaded) {
                mediamessageitem.download()
            } else {
                imagemessage.openImage();
            }
        }
    }
}
