import QtQuick 2.4
import Ubuntu.Components 1.3
import "../../component/view"

Page {
    id: root
    header: PageHeader {
        title: qsTr("Contacts")
    }

    property var context


    ContactList {
        id: lvcontacts
        context: root.context
        anchors.fill: parent
        anchors.topMargin: root.header.height
        clip: true

        header: TextField {
            width: lvcontacts.width
            placeholderText: qsTr("Search...")
        }

        onContactSelected: root.startConversation
    }
}
