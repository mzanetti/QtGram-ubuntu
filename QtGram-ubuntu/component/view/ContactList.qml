import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import LibQTelegram 1.0
import "../../item"
import "../../model"

ListView
{
    id: root
    property var context

    signal contactSelected()

    Label {
        anchors.centerIn: parent
        text: qsTr("No contacts")
        visible: root.count == 0
    }

    model: root.context.contacts

    section.property: "firstLetter"

    section.delegate: Item {
        width: parent.width
        height: units.gu(4)
        z: -1

        Label {
            anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); rightMargin: units.gu(1); verticalCenter: parent.verticalCenter }
            text: section
        }
        ThinDivider { anchors.bottom: parent.bottom }
    }

    delegate: ContactModelItem {
        context: root.context
        width: parent.width

        onClicked: {
            root.context.contacts.createDialog(model.item);
            contactSelected();
        }
    }
}
