#! /bin/bash
#####################    CONSTANTS TO CHANGE      ################################
PATH_DATA="/home/mvilchis/Desktop/Presidencia/rapidpro_files/misalud/import_flows/io_jsons/"

#################### CONSTANTS ####################
LIST_FLOWS='flows_to_import.txt'
HUGE_FLOW="final_import.json"
HEADER='{ "campaigns": [], "version": 10,"site": "https://app.rapidpro.io", "flows": ['
FOOTER='],"triggers": []}'

echo $HEADER>$HUGE_FLOW
for flow_id in `(cat $LIST_FLOWS| sort | uniq)`; do
    cat "$PATH_DATA$flow_id.json" >>$HUGE_FLOW
    echo -n ",">>$HUGE_FLOW
done
echo $FOOTER>>$HUGE_FLOW
