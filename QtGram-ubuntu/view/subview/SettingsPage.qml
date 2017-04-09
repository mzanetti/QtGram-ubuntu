import QtQuick 2.4
import Ubuntu.Components 1.3
import "../../model/"
Page {
    id: root
    header: PageHeader {
        title: "Settings"
    }

    property Context context: null

    Column {
        anchors.fill: parent
        anchors.topMargin: root.header.height

        Switch {
            onCheckedChanged: {
                if (checked) {
                    context.telegram.registerPush(pushClient.token);
                } else {
                    context.telegram.unregisterPush(pushClient.token);
                }
            }
        }
    }
}
