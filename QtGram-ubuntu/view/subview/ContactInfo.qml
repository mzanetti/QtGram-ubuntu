import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import LibQTelegram 1.0
import "../../js/Colors.js" as Colors
import "../../component"

Page {
    id: root
    header: PageHeader {
        title: i18n.tr("Contact details")
    }

    property alias peer: peerprofile.peer
    property var context

    signal sendMessage();

    PeerProfile {
        id: peerprofile
        telegram: context.telegram
    }

    Column {
        anchors { left: parent.left; top: parent.top; right: parent.right; margins: units.gu(2); topMargin: root.header.height + units.gu(2) }
        spacing: units.gu(1)

        RowLayout {
            width: parent.width
            spacing: units.gu(2)

            PeerImage {
                size: titleColumn.height
                Layout.preferredHeight: size
                Layout.preferredWidth: height
                backgroundColor: root.peer && root.peer.userId ? Colors.getColor(root.peer.userId) : "black"
                foregroundColor: "black"
                peer: root.peer
            }

            Column {
                id: titleColumn
                Layout.fillWidth: true
                spacing: units.gu(1)

                Label {
                    text: peerprofile.title
                    fontSize: "large"
                    elide: Text.ElideRight
                    width: parent.width
                }
                Label {
                    text: peerprofile.statusText
                }
                Button {
                    text: i18n.tr("Send message")
                    color: UbuntuColors.blue
                    onClicked: root.sendMessage()
                }
            }
        }

        ThinDivider {}

        Label {
            text: i18n.tr("Info")
            fontSize: "large"
        }

        RowLayout {
            width: parent.width
            spacing: units.gu(1)
            visible: peerprofile.phoneNumber

            Label {
                text: i18n.tr("Mobile:")
            }

            Label {
                text: "+" + peerprofile.phoneNumber
                Layout.fillWidth: true
            }
        }
        RowLayout {
            width: parent.width
            spacing: units.gu(1)

            Label {
                text: i18n.tr("Username:")
            }
            Label {
                Layout.fillWidth: true
                text: peerprofile.username
            }
        }
        Label {
            text: i18n.tr("Settings")
            fontSize: "large"
        }
        RowLayout {
            width: parent.width
            spacing: units.gu(1)
            CheckBox {
                checked: !peerprofile.isMuted
                onClicked: peerprofile.isMuted = !peerprofile.isMuted
            }
            Label {
                Layout.fillWidth: true
                text: "Notifications"
            }
        }
    }
}

