import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3
import LibQTelegram 1.0
import "../../item"
import "../../component/message"
import "../../component/view"
import "../../component"

Page {
    id: root
    clip: true

    header: PageHeader {
        contents: RowLayout {
            anchors.fill: parent;
            PeerImage {
                Layout.preferredWidth: size
                Layout.preferredHeight: size
                size: units.gu(4)
                height: size
                width: size
                peer: tgDialog
                backgroundColor: "gray"
                foregroundColor: "black"
            }
            ColumnLayout {
                Layout.fillWidth: true
                Label {
                    text: messagesmodel.title
                    Layout.fillWidth: true
                }
                Label {
                    text: messagesmodel.statusText
                    Layout.fillWidth: true
                    fontSize: "small"
                }
            }
        }

        leadingActionBar.actions: [
            Action {
                iconName: messagesListView.selectMode ? "close" : "back"
                onTriggered: {
                    if (messagesListView.selectMode) {
                        messagesListView.selectMode = false;
                    } else {
                        apl.removePages(root);
                    }
                }
            }
        ]

        trailingActionBar.actions: [
            Action {
                iconName: "contact"
                onTriggered: {
                    var incubator = apl.addPageToNextColumn(root, Qt.resolvedUrl("ContactInfo.qml"), { context: root.context, peer: tgDialog });
                    if (incubator.status !== Component.Ready) {
                        incubator.onStatusChanged = function(status) {
                            if (status === Component.Ready) {
                                incubator.object.sendMessage.connect(function() {root.openDialog(tgDialog)})
                            }
                        }
                    } else {
                        incubator.object.sendMessage.connect(function() {root.openDialog(tgDialog)})
                    }
                }
            },
            Action {
                iconName: "mail-forward"
                visible: messagesListView.selectMode && messagesListView.selectedMessages.length > 0
                onTriggered: {
                    print("should forward", messagesListView.selectedMessages.length, "messages")
                    var messages = [];
                    for (var i = 0; i < messagesListView.selectedMessages.length; i++) {
                        messages.push(messagesmodel.get(messagesListView.selectedMessages[i]));
                    }
                    root.forwardMessages(messages)
                }
            }
        ]
    }

    property var context: null
    property var tgDialog: null
    property var editingMessage: null
    property var replyToMessage: null

    signal openDialog(var dialog);

    signal forwardMessages(var messages);

    function doForwardMessage(messages) {
        print("doing forward!!!!!", messages)
        messagesmodel.forwardMessages(tgDialog, messages)
    }

    Rectangle {
        anchors.fill: parent
        color: "#b5bbcb"
    }

    MessagesModel
    {
        id: messagesmodel
        telegram: root.context.telegram
        dialog: root.tgDialog
        isActive: Qt.application.state === Qt.ApplicationActive
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: root.header.height
        anchors.bottomMargin: Qt.inputMethod.keyboardRectangle.height
        spacing: 0

        ListView {
            id: messagesListView
            model: messagesmodel
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalLayoutDirection: ListView.BottomToTop
            spacing: units.gu(1)
            maximumFlickVelocity: 2500 * units.gu(1) / 8
            flickDeceleration: 1500 * units.gu(1) / 8
            topMargin: units.gu(1)
            bottomMargin: units.gu(1)

            property bool selectMode: false
            property var selectedMessages: ViewItems.selectedIndices

            Component.onCompleted: messagesListView.positionViewAtIndex(messagesmodel.newMessageIndex, ListView.Center);

            delegate: MessageModelItem {
                context: root.context
                isChat: messagesmodel.isChat
                selectMode: messagesListView.selectMode

                onPressAndHold: {
                    messagesListView.selectMode = true;
                }

                onOpenImage: {
                    apl.addPageToCurrentColumn(root, Qt.resolvedUrl("ImagePreview.qml"), { source: source, from: messagesmodel.title})
                }

                onOpenFile: {
                    apl.addPageToNextColumn(root, Qt.resolvedUrl("ContentHubPage.qml"), { handler: ContentHandler.Destination, contentType: ContentType.All, source: source })
                }

                onPeerImageClicked: {
                    // Don't have a way to get to something that openDialog would eat...
                    apl.addPageToNextColumn(root, Qt.resolvedUrl("ContactInfo.qml"), {context: root.context, peer: model.item })
    //                root.openDialog(model.item)
                }

                onEditMessage: {
                    actionMessagePanel.open("edit", "Edit message", model.messageText);
                    root.editingMessage = model.item;
                    messagetextinput.setContent(model.messageText)
                    messagetextinput.forceActiveFocus()
                }

                onForwardMessage: {
                    print("emitting forward message")
                    root.forwardMessages([model.item]);
                }

                onReplyToMessage: {
                    actionMessagePanel.open("mail-reply", model.messageFrom, model.messageText);
                    root.replyToMessage = model.item;
                    messagetextinput.forceActiveFocus();
                }
            }

            Rectangle {
                height: units.gu(6)
                width: height
                radius: width / 2
                color: Qt.rgba(UbuntuColors.ash.r, UbuntuColors.ash.g, UbuntuColors.ash.b, .3)
                anchors { right: parent.right; bottom: parent.bottom; margins: units.gu(1) }
                opacity: messagesListView.contentY - messagesListView.originY < messagesListView.contentHeight - messagesListView.height * 1.5 ? 1 : 0
                visible: opacity > 0
                Behavior on opacity { NumberAnimation { duration: 200; } }
                Text {
                    anchors.centerIn: parent
                    text: " 🠋"
                    font.pixelSize: parent.height / 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: messagesListView.positionViewAtIndex(0, ListView.bottom)
                }
            }
        }

        ActionMessagePanel {
            id: actionMessagePanel
            Layout.fillWidth: true
            Layout.preferredHeight: active ? implicitHeight + units.gu(2) : 0
            clip: true
            Behavior on Layout.preferredHeight { UbuntuNumberAnimation {} }

            onActiveChanged: {
                if (active) stickersPanel.active = false;
            }

            onCancel: {
                root.editingMessage = null
                root.replyToMessage = null
            }
        }

        StickersPanel {
            id: stickersPanel
            context: root.context

            Layout.fillWidth: true
            Layout.preferredHeight: active ? root.height / 2 : 0
            clip: true

            onActiveChanged: {
                if (active) actionMessagePanel.cancel()
            }

            Behavior on Layout.preferredHeight { UbuntuNumberAnimation {} }

            onStickerSelected: {
                messagesmodel.sendSticker(sticker)
                active = false;
            }
        }

        MessageTextInput
        {
            id: messagetextinput
            focus: true

            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight

            onSendRequested: {
                if (root.editingMessage) {
                    messagesmodel.editMessage(content, root.editingMessage);
                    actionMessagePanel.cancel();
                } else if (root.replyToMessage) {
                    messagesmodel.replyMessage(content, root.replyToMessage);
                    actionMessagePanel.cancel();
                } else {
                    messagesmodel.sendMessage(content)
                }
            }
            onSendAction: {
                messagesmodel.sendAction(action)
            }
            onSendFile: {
                var incubator = apl.addPageToNextColumn(root, Qt.resolvedUrl("ContentHubPage.qml"), {handler: ContentHandler.Source, contentType: ContentType.Pictures})
                if (incubator.status != Component.Ready) {
                    incubator.onStatusChanged = function(status) {
                        if (status == Component.Ready) {
                            incubator.object.filesImported.connect(function(fileList) {
                                doSendFiles(fileList)
                            })
                        }
                    }
                } else {
                    incubator.object.filesImported.connect(function(fileList) {
                        doSendFiles(fileList)
                    })
                }
            }
            onOpenStickers: {
                stickersPanel.active = !stickersPanel.active
            }

            function doSendFiles(fileList) {
                for (var i = 0; i < fileList.length; i++) {
                    print("seding foto:", fileList[i])
                    messagesmodel.sendPhoto(fileList[i], "");
                }
            }
        }
    }
}
