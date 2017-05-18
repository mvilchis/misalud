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


TOKEN="4183ab77c3ca4f01daa3b3e332222c55411f21cf"
URL_FLOW_BY_CAMPAIGN="https://app.rapidpro.io/api/v2/campaign_events.json"
URL_DESCRIPTION_FLOW="https://app.rapidpro.io/api/v2/definitions.json"

LIST_CAMPAIGN=("9ea19f24-bdc3-4fe9-bf37-5301d4c1f385" "41927fb7-37ee-4f5b-846c-71cf0acabba1" "a7e2b278-238d-445c-9923-abb5aae9cadc" "33cfdd37-5150-4a4b-a3e7-0e7ae419a86b" "6fbbab3b-3167-4d74-ae79-f590b6df3877" "7477b32e-8d7f-4600-a9ba-b8c5aa69ef22" "d6f30a53-6be6-42c7-910d-7cfdcb0ca0a3" "b0d8bedb-35b5-4972-ba4e-e6d4689be1f3" "645e6a30-ecb1-484d-977e-a6723ab5992b" "0324bae6-46c5-456d-84a9-2be41b021668" "db1186ac-d552-47b9-8e33-1574c6c4506c" "6e66257e-c213-4487-804e-d8eb399bbbac" "3fec8bcc-f7c2-49ed-9079-c5972e7f4eb6")

#Se obtienen los flujos por cada campaña con el offset del flujo
function  get_flows_by_campaign() {
  uuid_campaign="$1"
  json_flows=`curl -s -H "Accept:application/json"\
        -H "content-type: application/json"\
        -H "Authorization: token  $TOKEN"\
        "$URL_FLOW_BY_CAMPAIGN?campaign=$uuid_campaign"`
  echo $json_flows| jq '.results[]|{"relative_to":"\(.relative_to["key"])","offset":"\(.offset)","flow":"\(.flow["uuid"])"}'
}


#Descomentar para obtener todos los jsons de todos los flujos involucrados en las


#all_camp=($(get_campaigns))
for campaign in ${LIST_CAMPAIGN[@]}
do
  echo $campaign "<<<-"
  #flow_id=($())
  for flow_i in `get_flows_by_campaign $campaign|jq '.flow'`
  do
    echo $flow_i" " >> jsons_to_work
  done
done

cat jsons_to_work |sort| uniq > json_list
rm jsons_to_work
