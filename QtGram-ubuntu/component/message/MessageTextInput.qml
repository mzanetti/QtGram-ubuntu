import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.1
import LibQTelegram 1.0

FocusScope {
    id: root
    implicitHeight: rowLayout.height + units.gu(2)
    onImplicitHeightChanged: print("parent height changed", height)
    Rectangle {
        anchors.fill: parent
    }

    function setContent(content) {
        tisendmessage.text = content
    }

    signal sendRequested(string content)
    signal sendAction(var action)
    signal sendFile();
    signal openStickers();

    Row {
        id: rowLayout
        anchors { left: parent.left; top: parent.top; right: parent.right }
        anchors.margins: units.gu(1)
        height: tisendmessage.height
        spacing: units.gu(1)

        AbstractButton
        {
            height: btnsend.height
            width: height
            anchors.bottom: parent.bottom
            Icon {
                anchors.fill: parent
                name: "attachment"
            }
            activeFocusOnPress: false

            onClicked: {
                root.sendFile();
            }
        }

        TextArea {
            id: tisendmessage
            placeholderText: qsTr("Send message...")
            width: parent.width - x - stickersButton.width - btnsend.width - 2*rowLayout.spacing
            autoSize: true
            Layout.preferredHeight: implicitHeight
            onHeightChanged: print("height changed", height)
            focus: true
            Keys.onReturnPressed: {
                root.sendRequested(tisendmessage.displayText);
                tisendmessage.text = "";
            }

            onDisplayTextChanged: {
                if(displayText.length < 2)
                    return;
                root.sendAction(MessagesModel.TypingAction);
            }
        }

        AbstractButton {
            id: stickersButton
            height: btnsend.height
            width: height
            anchors.bottom: parent.bottom

            Label {
                anchors.centerIn: parent
                text: "😃"
                fontSize: "x-large"
                color: UbuntuColors.warmGrey
            }
            onClicked: root.openStickers()
        }

        AbstractButton {
            id: btnsend
            width: height
            height: units.gu(4)
            anchors.bottom: parent.bottom
            activeFocusOnPress: false

            Icon {
                anchors.fill: parent
                name: "send"
            }
            onClicked: {
                root.sendRequested(tisendmessage.displayText);
                tisendmessage.text = "";
            }
        }
    }
}
