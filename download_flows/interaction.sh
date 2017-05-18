#! /bin/bash

#Primero se listan las campañas, calendario de flujos de la organizacion
#    funcion get_campaigns

#Despues por cada campaña se extrae
#    -> relative_to: variable relativa en la que se basa el flujo
#                  (relative_to puede ser "dia_de_embarazo")
#    -> cuando detona (inicia) un flujo  esta definido po
#                  variable_realtiva + offset
#    -> cual flujo se va a detonar: uuid
#    funcion get_flows_by_campaign
#En este momento se puede calcular todo el calendario de un usuario
#Y el nombre de los flujos que se van a detonar en cada fecha

#Falta que con el uuid de un flujo obtengas el json del flujo.
# Iria en la funcion get_json_flow


TOKEN="436d7fcbf36d026aba085a8adfa7f14796c06a38"
URL_LIST_CAMPAIGNS="https://rapidpro.datos.gob.mx/api/v2/campaigns.json"
URL_FLOW_BY_CAMPAIGN="https://rapidpro.datos.gob.mx/api/v2/campaign_events.json"
URL_DESCRIPTION_FLOW='https://rapidpro.datos.gob.mx/api/v2/definitions.json'

#Se obtienen todas las campañas de la organizacion
function get_campaigns() {
  json_campaigns=`curl  -H 'Accept:application/json'\
        -H 'content-type: application/json'\
        -H 'Authorization: token  '$TOKEN\
        $URL_LIST_CAMPAIGNS`
  echo $json_campaigns| jq '.results[]|.uuid'
}

#Se obtienen los flujos por cada campaña con el offset del flujo
function  get_flows_by_campaign() {
  uuid_campaign=`echo "$1"|sed 's/"//g'`
  json_flows=`curl -s -H "Accept:application/json"\
        -H "content-type: application/json"\
        -H "Authorization: token  $TOKEN"\
        "$URL_FLOW_BY_CAMPAIGN?campaign=$uuid_campaign"`
  echo $json_flows| jq '.results[]|{"relative_to":"\(.relative_to["key"])","offset":"\(.offset)","flow":"\(.flow["uuid"])"}'
}

#Se obtiene el json del flujo por uuid
function get_json_flow() {
  uuid_flow=`echo "$1"|sed 's/"//g'`
  if [ ! -f "$uuid_flow.json" ]; then
    json_flow=`curl -s -H "Accept:application/json"\
          -H "content-type: application/json"\
          -H "Authorization: token  $TOKEN"\
          "$URL_DESCRIPTION_FLOW?flow=$uuid_flow"`
    echo $json_flow > "$uuid_flow.json"
  fi
}


get_json_flow "b412dfe0-eb72-4d3d-80e0-d93c45b353a4"

#Descomentar para obtener todos los jsons de todos los flujos involucrados en las


#all_camp=($(get_campaigns))
#for campaign in ${all_camp[@]}
#do
#  flows_id=`get_flows_by_campaign $campaign|jq '.flow'`
#  for flow_id in ${flows_id[@]}
#  do
#    get_json_flow $flow_id
#  done
#done
