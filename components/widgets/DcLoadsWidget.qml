/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import QtQuick.Layouts
import Victron.VenusOS

OverviewWidget {
	id: root

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
			dataObject: Global.system.dc
			sourceType: VenusOS.ElectricalQuantity_Source_Dc
			Layout.fillWidth: true
			Layout.fillHeight: true
		}

		Text {
			visible: Global.system.dc.hasPower
			text: {
				let values = []
				if (!isNaN(Global.system.dc.voltage))
					values.push(Global.system.dc.voltage.toFixed(1) + " V")
				if (!isNaN(Global.system.dc.current))
					values.push(Global.system.dc.current.toFixed(1) + " A")
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

	FilteredDeviceModel {
		id: systemLoadDevices
		serviceTypes: ["dcsystem"]
	}

	FilteredDeviceModel {
		id: nonSystemLoadDevices
		serviceTypes: ["dcload", "dcdc", "motordrive"]
	}
}
