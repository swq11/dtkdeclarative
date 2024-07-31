// SPDX-FileCopyrightText: 2024 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.11
import QtQuick.Templates as T
import org.deepin.dtk.style 1.0 as DS
import org.deepin.dtk.private 1.0 as P

ListView {
    id: control
    property int duration: 100
    property bool bgVisible: false
    property Item hoveredItem

    onContentXChanged: {
        if (hoveredItem && hoveredItem.hovered && background)
            background.x = hoveredItem.x - contentX
    }

    onContentYChanged: {
        if (hoveredItem && hoveredItem.hovered && background)
            background.y =  hoveredItem.y - contentY
    }

    function setHoverItem(item) {
        if (item) {
            hoveredItem = item
            // if hover from null to item do not show animation
            bgVisible = (background.x <= 0 && background.y <= 0) ? false : hoveredItem.hovered
            background.x = hoveredItem.x - contentX
            background.y = hoveredItem.y - contentY
            background.width = hoveredItem.implicitWidth
            background.height = hoveredItem.implicitHeight
            bgVisible = hoveredItem.hovered
            control.state = bgVisible ? "Visible" : "Invisible"
        } else {
            hideTimer.start()
        }
    }

    // ItemDelegate hover item0 ==> item1, add timer ignore [item0.unhovered]
    // item0.hovered, item0.unhovered, item1.hovered
    Timer {
        id: hideTimer
        interval: control.duration
        onTriggered: {
            bgVisible = hoveredItem ? hoveredItem.hovered : false
            control.state = bgVisible ? "Visible" : "Invisible"
        }
    }

    // visible animation
    states: [
        State{
            name: "Visible"
            PropertyChanges { target: background; opacity: 1.0 }
            PropertyChanges { target: background; scale: 1.0 }
            PropertyChanges { target: background; visible: true }
        },
        State{
            name:"Invisible"
            PropertyChanges { target: background; opacity: 0.0 }
            PropertyChanges { target: background; scale: 0.5 }
            PropertyChanges { target: background; visible: false }
        }
    ]

    transitions: [
        Transition {
            from: "Visible"
            to: "Invisible"

            SequentialAnimation {
               ParallelAnimation {
                   NumberAnimation {
                       target: background
                       property: "opacity"
                       duration: control.duration
                       easing.type: Easing.InOutQuad
                   }
                   NumberAnimation {
                       target: background
                       property: "scale"
                       duration: control.duration
                       easing.type: Easing.InOutQuad
                   }
               }
               NumberAnimation {
                   target: background
                   property: "visible"
                   duration: 0
               }
            }
        },
        Transition {
            from: "Invisible"
            to: "Visible"
            SequentialAnimation {
                NumberAnimation {
                    target: background
                    property: "visible"
                    duration: 0
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: background
                        property: "opacity"
                        duration: control.duration
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: background
                        property: "scale"
                        duration: control.duration
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    ]

    Item {
        id: background
        implicitWidth: DS.Style.itemDelegate.width
        implicitHeight: DS.Style.itemDelegate.height
        z: -1

        Loader {
            anchors.fill: parent
            active: hoveredItem
            sourceComponent: P.ButtonPanel {
                button: hoveredItem
                outsideBorderColor: null
                visible: hoveredItem && !hoveredItem.checked && hoveredItem.enabled
            }
        }

        onVisibleChanged: {
            if (!visible) {
                // ensure do not show animation when hoveredItem from null to item
                background.x = -1
                background.y = -1
            }
        }

        // move and resize animation
        Behavior on x {
            enabled: bgVisible
            NumberAnimation { duration: control.duration }
        }
        Behavior on y {
            enabled: bgVisible
            NumberAnimation { duration: control.duration }
        }
        Behavior on width {
            enabled: bgVisible
            NumberAnimation { duration: control.duration }
        }
        Behavior on height {
            enabled: bgVisible
            NumberAnimation {  duration: control.duration }
        }
    }
}