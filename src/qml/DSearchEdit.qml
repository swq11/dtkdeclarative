/*
 * Copyright (C) 2020 ~ 2021 Deepin Technology Co., Ltd.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.11
import QtQuick.Controls 2.4
import com.deepin.dtk 1.0

/*
    DSearchEdit 控件：
    等同于 dtkwidget 里边的 DSearchEdit 控件。
*/

DLineEdit {
    id: control

    // 暴露给外部的属性
    property alias placeholder: centerIndicatorLabel.text

    leftPadding: !centerIndicator.visible? searchIcon.width : 0

    // 搜索框中心处字符提示信息，聚焦后隐藏
    Item {
        id: centerIndicator

        anchors.fill: parent
        visible: (!control.activeFocus) && (control.text.length === 0)

        Label {
            id: centerIndicatorLabel

            x: control.width / 2
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                control.forceActiveFocus(Qt.MouseFocusReason)
            }
        }
    }

    // 搜索图标
    DIcon {
        id: searchIcon

        x: centerIndicator.visible? (control.width / 2) - width : 0
        anchors.verticalCenter: parent.verticalCenter
        name: "search_action"
    }
}
