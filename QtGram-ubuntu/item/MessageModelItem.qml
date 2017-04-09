import QtQuick 2.4
import Ubuntu.Components 1.3
import LibQTelegram 1.0
import QtQuick.Layouts 1.1
import "../js/TextElaborator.js" as TextElaborator
import "../js/Colors.js" as Colors
import "../component/message"
import "../component/message/media"
import "../component/message/reply"
import "../component"

ListItem {
    id: root
    height: layout.height + (statusLabel.visible ? statusLabel.implicitHeight + units.gu(1) : 0)

    property var context: null
    property bool isChat: false
    property real maxWidth: Math.min(units.gu(80), root.width - (showPeerImages ? units.gu(12) : units.gu(6)))
    property bool showPeerImages: (isChat && !model.isMessageOut) || root.width >= units.gu(100)

    divider.colorFrom: "transparent"
    divider.colorTo: "transparent"

    readonly property bool isMediaItem: mediamessageitem.isSticker || mediamessageitem.isAnimated

    signal openImage(string source)
    signal openFile(string source);
    signal peerImageClicked();
    signal editMessage()
    signal forwardMessage()
    signal replyToMessage()

    property bool hasActions: !model.isMessageService
    trailingActions: hasActions ? messageActions : null
    property ListItemActions messageActions: ListItemActions {
        actions: [
            Action {
                text: "Copy"
                iconName: "edit-copy"
                visible: lblmessage.text
                onTriggered: {
                    Clipboard.push(lblmessage.text)
                }
            },
            Action {
                text: "Edit"
                iconName: "edit"
                visible: model.isMessageOut
                onTriggered: {
                    root.editMessage()
                }
            },
            Action {
                text: "Reply"
                iconName: "mail-reply"
                onTriggered: {
                    root.replyToMessage();
                }
            },
            Action {
                text: "Forward"
                iconName: "mail-forward"
                onTriggered: {
                    root.forwardMessage();
                }
            }
        ]
    }

    Label {
        id: statusLabel
        anchors { left: parent.left; right: parent.right }
        horizontalAlignment: Text.AlignHCenter
        text: "New Messages"
        visible: model.isMessageNew
    }

    Row {
        id: layout
        anchors {
            left: parent.left;
            bottom: parent.bottom;
            right: parent.right
            leftMargin: units.gu(1)
            rightMargin: units.gu(1)
        }
        height: contentItem.height
        spacing: units.gu(1)

        AbstractButton {
            width: units.gu(4)
            height: units.gu(4)
            visible: root.showPeerImages
            activeFocusOnPress: false
            onClicked: {
                root.peerImageClicked();
            }

            PeerImage
            {
                id: peerimage
                size: units.gu(4)
                peer: model.needsPeerImage ? model.item : null
                visible: model.needsPeerImage
                backgroundColor: Colors.getColor(model.item.fromId)
                foregroundColor: "black"
            }
        }

        Item {
            id: contentItem
            height: contentShape.height
            width: parent.width - x

            UbuntuShape {
                id: contentShape
                property bool hasShape: !isMediaItem && !isMessageService
                height: content.height + (hasShape || isMediaItem ? units.gu(2) : 0)
                backgroundColor: hasShape ? (model.item.isOut ? "#effdde" : "white") : "transparent"
                aspect: UbuntuShape.Flat


                width: {
                    if(model.isMessageService)
                        return maxWidth;

                    var w = Math.max(messageStatus.implicitWidth,
                                     messagereply.calculatedWidth,
                                     lblfrom.contentWidth,
                                     lblmessage.contentWidth,
                                     Math.min(mediamessageitem.contentWidth, mediamessageitem.maxMediaWidth))
                            + units.gu(2)
                    return Math.min(w, maxWidth);
                }

                anchors {
                    right: model.isMessageService || (model.item.isOut && root.width < units.gu(100)) ? parent.right : undefined
                    left: model.isMessageService || !model.item.isOut || root.width >= units.gu(100) ? parent.left : undefined
                }
                Column {
                    id: content
                    height: childrenRect.height
                    spacing: units.gu(.5)
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: units.gu(1)
                    }

                    MessageText
                    {
                        id: lblfrom
                        visible: (!model.isMessageService && root.showPeerImages && model.needsPeerImage && !isMediaItem && root.isChat)
                                || model.isMessageForwarded
                        font.weight: Font.DemiBold
                        emojiPath: context.qtgram.emojiPath
                        width: maxWidth - units.gu(2)
                        horizontalAlignment: Text.AlignLeft
                        rawText: model.isMessageForwarded ? qsTr("Forwarded from %1").arg(model.forwardedFromName) : model.messageFrom
                        color: model.isMessageForwarded ? Colors.getColor(model.forwardedFromPeer.id) : Colors.getColor(model.fromId)
                    }

                    MessageReplyItem
                    {
                        id: messagereply
                        width: parent.width
                        quoteColor: model.isMessageOut ? UbuntuColors.green : UbuntuColors.blue
                        fromColor: model.messageHasReply ? Colors.getColor(model.replyItem.fromId) : "black"
                        visible: model.messageHasReply
                    }

                    MediaMessageItem
                    {
                        id: mediamessageitem
                        message: model.item
                        size: Math.min(parent.width, units.gu(30))
                        anchors.right: model.isMessageOut ? parent.right : undefined

                        property int maxMediaWidth: Math.min(root.maxWidth - units.gu(2), units.gu(30))

                        imageDelegate: ImageMessage {
                            anchors.fill: parent
                            needsBlur: !mediamessageitem.downloaded
                            source: "file://" + mediamessageitem.source
                            onOpenImage: {
                                root.openImage(source)
                            }
                        }

                        stickerDelegate: StickerMessage {
                            anchors.fill: parent
                        }

                        animatedDelegate: AnimatedMessage {
                            anchors.fill: parent
                            source: "file://" + mediamessageitem.source
                        }

                        locationDelegate: LocationMessage {
                            title: mediamessageitem.venueTitle
                            address: mediamessageitem.venueAddress

                            source: {
                                return context.locationThumbnail(mediamessageitem.geoPoint.latitude,
                                                                 mediamessageitem.geoPoint.longitude,
                                                                 maxWidth, maxWidth, 14)
                            }
                        }

                        webPageDelegate: WebPageMessage {
                            width: Math.min(calculatedWidth, mediamessageitem.maxMediaWidth)
                            quoteColor: model.isMessageOut ? UbuntuColors.green : UbuntuColors.blue
                            context: root.context
                            title: mediamessageitem.webPageTitle
                            description: mediamessageitem.webPageDescription
                            messageText: model.messageText
                            source: "file://" + mediamessageitem.source
                        }

                        audioDelegate: AudioMessage {
                            width: Math.min(contentWidth, mediamessageitem.maxMediaWidth)
                            duration: mediamessageitem.duration
                            barColor: model.isMessageOut ? UbuntuColors.green : UbuntuColors.blue
                            source: model.item
                        }

                        fileDelegate: FileMessage {
                            width: Math.min(contentWidth, mediamessageitem.maxMediaWidth)
                            fileName: mediamessageitem.fileName
                            fileSize: mediamessageitem.fileSize

                            onOpen: root.openFile(mediamessageitem.source)
                        }
                    }

                    Label {
                        id: lblmessage
                        width: maxWidth - units.gu(2)
                        property bool openUrls: true
                        property string rawText: model.isMessageMedia ? model.messageCaption : model.messageText
                        text: TextElaborator.elaborate(rawText, context.qtgram.emojiPath, font.pixelSize, "#1a96cd", openUrls)
                        wrapMode: Text.Wrap
                        visible: text
                        onLinkActivated: Qt.openUrlExternally(link)
                        horizontalAlignment: model.isMessageService ? Text.AlignHCenter : Text.AlignLeft
                    }
                    MessageStatus {
                        id: messageStatus
                        width: parent.width
                        height: visible ? implicitHeight : 0
                        visible: !model.isMessageService
                        timestamp: model.messageDate
                        isMessageUnread: model.isMessageUnread
                        isMessageOut: model.isMessageOut
                        isMessagePending: model.isMessagePending
                        color: isMediaItem ? "white" : (isMessageOut ? UbuntuColors.green : UbuntuColors.ash)
                    }
                }
            }

        }
    }
}
