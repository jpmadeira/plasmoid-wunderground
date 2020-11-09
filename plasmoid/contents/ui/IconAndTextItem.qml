/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */


import QtQuick 2.9
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

GridLayout {
    id: iconAndTextRoot

    property alias iconSource: svg.imagePath
    property alias text: label.text
    property bool vertical: false

    readonly property int minimumIconSize: units.iconSizes.small
    readonly property int iconSize: iconAndTextRoot.vertical ? width : height

    columns: iconAndTextRoot.vertical ? 1 : 2
    rows: iconAndTextRoot.vertical ? 2 : 1

    columnSpacing: 0
    rowSpacing: 0

    PlasmaCore.SvgItem {
        id: icon

        readonly property int implicitMinimumIconSize: Math.max(iconSize, minimumIconSize)
        // reset implicit size, so layout in free dimension does not stop at the default one
        implicitWidth: minimumIconSize
        implicitHeight: minimumIconSize

        svg: PlasmaCore.Svg {
            id: svg
        }

        Layout.fillWidth: iconAndTextRoot.vertical
        Layout.fillHeight: !iconAndTextRoot.vertical
        Layout.minimumWidth: iconAndTextRoot.vertical ? minimumIconSize : implicitMinimumIconSize
        Layout.minimumHeight: iconAndTextRoot.vertical ? implicitMinimumIconSize : minimumIconSize
    }

    Item {
        id: text

        // Otherwise it takes up too much space while loading
        visible: label.text.length > 0

        Layout.fillWidth: iconAndTextRoot.vertical
        Layout.fillHeight: !iconAndTextRoot.vertical
        Layout.minimumWidth: iconAndTextRoot.vertical ? 0 : sizehelper.paintedWidth
        Layout.maximumWidth: iconAndTextRoot.vertical ? Infinity : Layout.minimumWidth

        Layout.minimumHeight: iconAndTextRoot.vertical ? sizehelper.paintedHeight : 0
        Layout.maximumHeight: iconAndTextRoot.vertical ? Layout.minimumHeight : Infinity

        Text {
            id: sizehelper

            font {
                family: label.font.family
                weight: label.font.weight
                italic: label.font.italic
                pixelSize: iconAndTextRoot.vertical ? theme.mSize(theme.defaultFont).height * 2 : 1024 // random "big enough" size - this is used as a max pixelSize by the fontSizeMode
            }
            minimumPixelSize: theme.mSize(theme.smallestFont).height / 2
            fontSizeMode: iconAndTextRoot.vertical ? Text.HorizontalFit : Text.VerticalFit
            wrapMode: Text.NoWrap

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors {
                leftMargin: units.smallSpacing
                rightMargin: units.smallSpacing
            }
            // These magic values are taken from the digital clock, so that the
            // text sizes here are identical with various clock text sizes
            height: {
                var textHeightScaleFactor = 0.7;
                if (parent.height <= 26) {
                    textHeightScaleFactor = 0.9;
                }
                return Math.min (parent.height * textHeightScaleFactor, 3 * theme.defaultFont.pixelSize);
            }
            visible: false

            // pattern to reserve some constant space TODO: improve and take formatting/i18n into account
            text: "888.8° X"
        }

        PlasmaComponents.Label {
            id: label

            font {
                weight: Font.Normal
                pixelSize: 1024
                pointSize: 0 // we need to unset pointSize otherwise it breaks the Text.Fit size mode
            }
            minimumPixelSize: theme.mSize(theme.smallestFont).height / 2
            fontSizeMode: Text.Fit
            wrapMode: Text.NoWrap

            height: 0
            width: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors {
                fill: parent
                leftMargin: units.smallSpacing
                rightMargin: units.smallSpacing
            }
        }
    }
}