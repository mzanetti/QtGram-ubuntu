import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import LibQTelegram 1.0
import "../message"

Rectangle {
    id: root
    implicitHeight: previewContent.height

    property bool active: false

    function open(iconName, title, message) {
        icon.name = iconName;
        titleLabel.text = title;
        messageText.rawText = message;
        active = true;
    }

    signal cancel()

    onCancel: {
        root.active = false
    }

    RowLayout {
        id: previewContent
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: units.gu(1) }
//        height: childrenRect.height
        spacing: units.gu(1)

        Icon {
            id: icon
            Layout.preferredWidth: units.gu(3)
            Layout.preferredHeight: width
        }

        Column {
            height: childrenRect.height
            Layout.fillWidth: true
            spacing: units.gu(1)

            Label {
                id: titleLabel
                anchors { left: parent.left; right: parent.right }
                elide: Text.ElideRight
            }

            MessageText {
                id: messageText
                anchors { left: parent.left; right: parent.right }
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }
        }

        AbstractButton {
            Layout.preferredWidth: units.gu(3)
            Layout.preferredHeight: width
            activeFocusOnPress: false

            Icon {
                anchors.fill: parent
                name: "close"
            }

            onClicked: {
                root.cancel();
            }
        }
    }
}
