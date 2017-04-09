import QtQuick 2.4
import LibQTelegram 1.0
import Ubuntu.Components 1.3

ListItem {
    id: contactmodelitem
    height: units.gu(6)

    property var context

    ListItemLayout {
        title.text: model.fullName
        subtitle.text: model.statusText
        height: parent.height

        PeerImage
        {
            id: peerimage
            anchors { left: parent.left; top: parent.top }
            size: parent.height - units.gu(1)
            peer: model.item
            backgroundColor: "gray"
            foregroundColor: "black"
            fontPixelSize: size - units.gu(1)

            SlotsLayout.position: SlotsLayout.Leading
        }
    }
}
