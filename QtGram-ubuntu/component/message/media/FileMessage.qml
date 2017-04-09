import QtQuick 2.4
import Ubuntu.Components 1.3

Row
{
    id: root

    readonly property real contentWidth: image.width + Math.max(txthiddenfilename.contentWidth, txthiddenfilesize.contentWidth) + units.gu(1)
    property alias fileName: txthiddenfilename.text
    property alias fileSize: txthiddenfilesize.text

    spacing: units.gu(1)
    height: image.height

    signal open();

    Icon {
        id: image
        asynchronous: true
        width: height
        height: coltext.height
        name: "empty-symbolic"
        color: "black"

        ActivityIndicator {
            anchors.centerIn: parent
            visible: mediamessageitem.downloading
        }

        AbstractButton {
            anchors.fill: parent
            onClicked: {
                if (mediamessageitem.downloaded) {
                    mediamessageitem.download();
                } else {
                    root.open();
                }
            }
        }
    }

    Label { id: txthiddenfilename; visible: false }
    Label { id: txthiddenfilesize; visible: false }

    Column
    {
        id: coltext
        width: parent.width - image.width

        Label
        {
            id: txtfilename
            width: parent.width - units.gu(1)
            text: txthiddenfilename.text
            elide: Text.ElideRight
        }

        Label
        {
            id: txtfilesize
            width: parent.width
            text: txthiddenfilesize.text
            elide: Text.ElideRight
        }
    }
}
