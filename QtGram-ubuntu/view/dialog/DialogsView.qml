import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3 as UCP
import LibQTelegram 1.0
import "../../component"

Page {
    id: root

    header: PageHeader {
        title: context.telegram.connected ?
                   forwardingMessages.length == 0 ? "Conversations" : "Choose recipient..."
            : "Waiting for connection..."
        leadingActionBar.actions: [
            Action {
                iconName: "contact-group"
                name: "Contacts"
                onTriggered: {
                    apl.addPageToNextColumn(root, Qt.resolvedUrl("../subview/ContactsPage.qml"), {context: root.context})
                }
            }
        ]
        trailingActionBar.actions: [
            Action {
                iconName: "close"
                visible: forwardingMessages.length > 0
                onTriggered: {
                    forwardingMessages = [];
                }
            },
            Action {
                iconName: "settings"
                onTriggered: {
                    apl.addPageToNextColumn(root, Qt.resolvedUrl("../subview/SettingsPage.qml"), {context: root.context});
                }
            }

        ]
    }

    property var context: null


    // Internal for openDialog()
    property bool _doForward: false

    function openDialog(dialog) {
        if (!_doForward && forwardingMessages.length > 0) {
            var popup = PopupUtils.open(forwardDialogComponent, root, {messageCount: forwardingMessages.length, recipient: dialogsmodel.dialogTitle(dialog)})
            popup.accepted.connect(function() {
                _doForward = true;
                openDialog(dialog);
            })
            popup.rejected.connect(function() {
                forwardingMessages = [];
            })
            return;
        }
        _doForward = false;

        var incubator = apl.addPageToNextColumn(root, Qt.resolvedUrl("../subview/MessagesView.qml"),
                         { context: root.context, tgDialog: dialog });

        if (incubator.status != Component.Ready) {
            incubator.onStatusChanged = function(status) {
                if (status == Component.Ready) {
                    initConversation(incubator.object, dialog)
                }
            }
        } else {
            initConversation(incubator.object, dialog)
        }
    }

    function initConversation(page, dialog) {
        print("setting up conv")

        if (forwardingMessages.length > 0) {
            print("have", forwardingMessages.length, "messages to forward")
            page.doForwardMessage(forwardingMessages);
            forwardingMessages = [];
        }

        page.openDialog.connect(function(dialog) {
            root.openDialog(dialog);
        })
        page.forwardMessages.connect(function(messages){
            for (var i = 0; i < messages.length; i++) {
                forwardingMessages = messages;
            }
            apl.removePages(page)
        })
    }

    Connections {
        target: root.context.contacts
        onDialogCreated: {
            openDialog(dialog)
        }
    }

    property var forwardingMessages: []

    ListView {
        id: lvdialogs
        anchors.fill: parent
        anchors.topMargin: root.header.height
        maximumFlickVelocity: 2500 * units.gu(1) / 8
        flickDeceleration: 1500 * units.gu(1) / 8

        model: DialogsModel {
            id: dialogsmodel
            telegram: context.telegram
        }
        delegate: ListItem {
            id: conversationDelegate
            height: layout.height
            trailingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "info"
                        onTriggered: {
                            var incubator = apl.addPageToNextColumn(root, Qt.resolvedUrl("../subview/ContactInfo.qml"), {context: root.context, peer: model.item});
                            if (incubator.status != Component.Ready) {
                                incubator.onStatusChanged = function(status) {
                                    if (status == Component.Ready) {
                                        incubator.object.sendMessage.connect(function() {conversationDelegate.clicked()})
                                    }
                                }
                            } else {
                                incubator.object.sendMessage.connect(function() {conversationDelegate.clicked()})
                            }
                        }
                    }
                ]
            }

            ListItemLayout {
                id: layout
                title.text: model.title
                subtitle.text: {
                    var text = ""

                    if(model.draftMessage.length === 0 && !model.isBroadcast && (model.isChat || model.isMegaGroup) && (model.topMessage)) {
                        if(model.topMessage) {
                            text = "<b>" + (model.topMessage.isOut ? qsTr("You") : model.topMessageFrom) + ":</b> ";
                        }
                    }

                    if(model.draftMessage.length > 0)
                        text += qsTr("Draft: %1").arg(model.draftMessage);
                    else
                        text += model.topMessageText;

                    return text;
                }

                PeerImage
                {
                    id: peerimage
                    SlotsLayout.position: SlotsLayout.Leading;
                    size: units.gu(5)
                    peer: model.item
                    backgroundColor: "gray"
                    foregroundColor: "black"
                }

                Item {
                    width: units.gu(2)
                    height: units.gu(4)

                    Row {
                        anchors { top: parent.top; right: parent.right }
                        height: dateLabel.implicitHeight
                        Item {
                            height: parent.height
                            width: height * 1.3
                            visible: model.isTopMessageOut
                            Icon {
                                height: parent.height
                                width: height
                                anchors.left: parent.left
                                name: "tick"
                                color: UbuntuColors.green
                                visible: model.isTopMessageOut && !model.isTopMessageUnread
                            }
                            Icon {
                                height: parent.height
                                width: height
                                anchors.right: parent.right
                                name: "tick"
                                color: UbuntuColors.green
                                visible: model.isTopMessageOut
                            }
                        }
                        Label {
                            id: dateLabel
                            text: model.topMessageDate
                            fontSize: "small"
                        }
                    }

                    UbuntuShape {
                        anchors { bottom: parent.bottom; right: parent.right }
                        height: units.gu(2)
                        width: unreadCountLabel.implicitWidth + units.gu(1)
                        aspect: UbuntuShape.Flat
                        backgroundColor: UbuntuColors.green
                        visible: model.item.unreadCount > 0
                        Label {
                            id: unreadCountLabel
                            anchors.centerIn: parent
                            text: model.unreadCount
                            color: "white"
                            fontSize: "small"
                        }
                    }
                }
            }

            onClicked: {
                root.openDialog(model.item)
            }
        }
    }

    Component {
        id: forwardDialogComponent
        UCP.Dialog {
            id: forwardDialog
            title: "Forward messages"
            text: i18n.tr("Are you sure you want to forward <b>%1 messages</b> to <b>%2</b>?").arg(messageCount).arg(recipient)
            property int messageCount: 0
            property string recipient: ""

            signal accepted()
            signal rejected()

            Button {
                color: UbuntuColors.green
                text: "Yes"
                onClicked: {
                    print("yes!")
                    forwardDialog.accepted();
                    PopupUtils.close(forwardDialog)
                }
            }
            Button {
                color: UbuntuColors.orange
                text: "No, choose a different recipient"
                onClicked: {
                    PopupUtils.close(forwardDialog)
                }
            }
            Button {
                color: UbuntuColors.red
                text: "No, cancel forwarding"
                onClicked: {
                    forwardDialog.rejected()
                    PopupUtils.close(forwardDialog)
                }
            }
        }
    }
}
