import QtQuick 2.4
import LibQTelegram 1.0
import "../"

Item
{
    readonly property real calculatedWidth: Math.max(lblfrom.calculatedWidth,
                                                     mediamessageitem.contentWidth,
                                                     lblmessage.calculatedWidth)
                                            + messagequote.width + units.gu(1)

    property alias quoteColor: messagequote.color
    property alias fromColor: lblfrom.color

    id: messagereplyitem
    height: Math.max(previewcontent.height, mediamessageitem.height)

    Row
    {
        id: row
        width: parent.width
        height: parent.height
        spacing: units.gu(1)

        MessageQuote { id: messagequote; height: parent.height }

        MediaMessageItem
        {
            id: mediamessageitem
            message: model.messageHasReply ? model.replyItem : null
            size: units.gu(10)

            imageDelegate: MessageReplyImage {
                anchors.fill: parent
                source: "file://" + mediamessageitem.source
            }
        }

        Column
        {
            id: previewcontent
            width: parent.width

            MessageText
            {
                id: lblfrom
                font.weight: Font.DemiBold
                emojiPath: context.qtgram.emojiPath
                width: parent.width - units.gu(1)
                horizontalAlignment: Text.AlignLeft
                rawText: model.replyFrom
            }

            MessageText
            {
                id: lblmessage
                width: parent.width - units.gu(1)
                font { italic: true }
                emojiPath: context.qtgram.emojiPath
                rawText: model.replyText
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
//                color: Theme.textColor
                horizontalAlignment: Text.AlignLeft
            }
        }
    }
}
