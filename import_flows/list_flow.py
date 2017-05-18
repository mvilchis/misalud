from temba_client.v2 import TembaClient
import json

TOKEN_IO="bae15e0a8572ddb5f0e1c1fb8bb3733c84e3a746"

# Cliente io
io_client = TembaClient('rapidpro.io',TOKEN_IO)

#List_to_check
CAMPAIGN_LIST=["SE_C_Baby","SE_T_Baby", "Baby_T3" , "Baby" , "PREMATURE" , "SE_T_Pregnancy" , "MISCARRIAGE" , "MiAlerta" , "MiAlerta_followUp" , "SE_C_Pregnancy" , "Pregnancy" , "MiAlta" , "Pregnancy_T3"]

def get_flows_of_campaign(rp_client,campaign_name):
    list_events = rp_client.get_campaign_events(campaign = campaign_name).all()
    return [event.serialize()['flow']['uuid'] for event  in list_events if 'flow' in event.serialize()]

def main():
    thefile = open('flows_to_import.txt', 'w')
    for campaign in CAMPAIGN_LIST:
        result = get_flows_of_campaign(io_client, campaign)
        for item in result:
              print>>thefile, item

main()
