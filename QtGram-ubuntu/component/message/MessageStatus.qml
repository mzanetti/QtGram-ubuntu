import QtQuick 2.4
import Ubuntu.Components 1.3

Row {
    id: root
    height: label.implicitHeight
    property string timestamp
    property bool isMessageOut: false
    property bool isMessageUnread: false
    property bool isMessagePending: false
    property alias color: label.color

    layoutDirection: Qt.RightToLeft

    Item {
        height: parent.height
        width: height * 1.3
        visible: isMessageOut
        Icon {
            height: parent.height
            width: height
            anchors.left: parent.left
            name: "tick"
            color: root.color
            visible: isMessageOut && !root.isMessageUnread && !root.isMessagePending
        }
        Icon {
            height: parent.height
            width: height
            anchors.right: parent.right
            name: isMessagePending ? "clock" : "tick"
            color: root.color
            visible: root.isMessageOut
        }
    }

    Label {
        id: label
        text: root.timestamp
        color: root.color
        fontSize: "x-small"
    }
}
