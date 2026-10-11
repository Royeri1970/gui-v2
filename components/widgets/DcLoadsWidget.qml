/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import QtQuick.Layouts
import Victron.VenusOS

OverviewWidget {
    id: root

    readonly property real correctedPower: Global.system.dc.power
            + (!isNaN(dcdcCorrectionModel.totalCurrent) && !isNaN(Global.system.dc.voltage)
                ? dcdcCorrectionModel.totalCurrent * Global.system.dc.voltage
                : 0)
    readonly property real correctedCurrent: !isNaN(correctedPower)
            && !isNaN(Global.system.dc.voltage)
            && Global.system.dc.voltage !== 0
            ? correctedPower / Global.system.dc.voltage
            : NaN

    //% "DC Loads"
    title: qsTrId("overview_widget_dcloads_title")
    type: VenusOS.OverviewWidget_Type_DcLoads
    enabled: systemLoadDevices.count > 1 || nonSystemLoadDevices.count > 0

    contentItem: ColumnLayout {
        spacing: Theme.geometry_overviewPage_widget_content_spacing

        WidgetHeader {
            text: root.title
            icon.source: "qrc:/images/dcloads.svg"
            Layout.fillWidth: true
        }

        OverviewElectricalQuantityLabel {
            widgetSize: root.size
            dataObject: QtObject {
                readonly property real power: root.correctedPower
                readonly property real current: root.correctedCurrent
            }
            sourceType: VenusOS.ElectricalQuantity_Source_Dc
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }

        Text {
            visible: Global.system.dc.hasPower
            text: {
                let values = []
                if (!isNaN(Global.system.dc.voltage))
                    values.push(Global.system.dc.voltage.toFixed(1) + " V")
                return values.join("\n")
            }
            color: Theme.color_font_primary
            font.pixelSize: Theme.font_overviewPage_widget_quantityLabel_tiny
            Layout.fillWidth: true
        }
    }

    onClicked: {
        Global.pageManager.pushPage("/pages/loads/DcLoadListPage.qml", {
            title: root.title,
            systemModel: systemLoadDevices,
            nonSystemModel: nonSystemLoadDevices
        })
    }

    DcMeterDeviceModel {
        id: dcdcCorrectionModel
        serviceTypes: [ "dcdc" ]
    }

    FilteredDeviceModel {
        id: systemLoadDevices
        serviceTypes: ["dcsystem"]
    }

    FilteredDeviceModel {
        id: nonSystemLoadDevices
        serviceTypes: ["dcload", "dcdc", "motordrive"]
    }
}
