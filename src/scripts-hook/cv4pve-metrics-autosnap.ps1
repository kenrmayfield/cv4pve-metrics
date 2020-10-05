# This file is part of the cv4pve-metrics https://github.com/Corsinvest/cv4pve-metrics,
#
# This source file is available under two different licenses:
# - GNU General Public License version 3 (GPLv3)
# - Corsinvest Enterprise License (CEL)
# Full copyright and license information is available in
# LICENSE.md which is distributed with this source code.
#
# Copyright (C) 2016 Corsinvest Srl	GPLv3 and CEL
#
# Save metrics for autosnap on database InfluxDB

$INFLUXDB_HOST=""
$INFLUXDB_PORT="8086"
$INFLUXDB_NAME="db_proxmox"
$INFLUXDB_USER=""
$INFLUXDB_PASSWORD=""

if ( $Env:CV4PVE_AUTOSNAP_PHASE -eq "snap-create-abort" -or $Env:CV4PVE_AUTOSNAP_PHASE -eq "snap-create-post" ) {
    #url post
    $url="http://$($INFLUXDB_HOST):$INFLUXDB_PORT/write?db=$INFLUXDB_NAME"

    #data metrics
    $data="cv4pve-autosnap,vmid=$Env:CV4PVE_AUTOSNAP_VMID,type=$Env:CV4PVE_AUTOSNAP_VMTYPE,label=$Env:CV4PVE_AUTOSNAP_LABEL,vmname=$CV4PVE_AUTOSNAP_VMNAME,success=$Env:CV4PVE_AUTOSNAP_STATE success=$Env:CV4PVE_AUTOSNAP_STATE,duration=$Env:CV4PVE_AUTOSNAP_DURATION"

    if ( $INFLUXDB_USER -eq "" ) {
        #no login
        Invoke-WebRequest -Method Post -Body $data -Uri $url | Out-Null
    }
    else {
        #with login
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $INFLUXDB_USER,$INFLUXDB_PASSWORD)))
        Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Method Post -Body $data -Uri $url | Out-Null
    }
}