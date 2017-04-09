import QtQuick 2.4
import "../../message"

Column
{
    readonly property real calculatedWidth: Math.max(wpmessage.calculatedWidth,
                                                     wptitle.calculatedWidth,
                                                     wpdescription.calculatedWidth,
                                                     imgthumbnail.sourceSize.width)

    property var context
    property alias messageText: wpmessage.rawText
    property alias title: wptitle.rawText
    property alias description: wpdescription.rawText
    property alias source: imgthumbnail.source
    property alias quoteColor: messagequote.color

    id: webpageelement
    spacing: units.gu(1)

    MessageText
    {
        id: wpmessage
        emojiPath: context.qtgram.emojiPath
        width: parent.width
        wrapMode: Text.Wrap
    }

    Row
    {
        id: preview
        width: parent.width
        height: previewcontent.height
        spacing: units.gu(1)

        MessageQuote { id: messagequote; height: parent.height }

        Column
        {
            id: previewcontent
            width: parent.width - x
            spacing: units.gu(1)

            MessageText
            {
                id: wptitle
                emojiPath: context.qtgram.emojiPath
                visible: rawText.length > 0
                width: parent.width
                wrapMode: Text.Wrap
                font { bold: true }
                fontSize: "small"
            }

            MessageText
            {
                id: wpdescription
                emojiPath: context.qtgram.emojiPath
                visible: rawText.length > 0
                width: parent.width
                wrapMode: Text.Wrap
                font { italic: true }
                fontSize: "small"
            }

            Image
            {
                id: imgthumbnail
                width: parent.width
                asynchronous: true
                fillMode: Image.PreserveAspectFit
            }
        }
    }
}
