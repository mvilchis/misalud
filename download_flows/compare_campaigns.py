from temba_client.v2 import TembaClient
import json

TOKEN_IO="bae15e0a8572ddb5f0e1c1fb8bb3733c84e3a746"
TOKEN_MX="437883b4b826560e9f9557a90ff772c307783d3c"
# Cliente io
io_client = TembaClient('rapidpro.io',TOKEN_IO)
#Cliente gob.mx
mx_client = TembaClient('rapidpro.datos.gob.mx', TOKEN_MX)

#List_to_check
CAMPAIGN_LIST=["SE_C_Baby","SE_T_Baby", "Baby_T3" , "Baby" , "PREMATURE" , "SE_T_Pregnancy" , "MISCARRIAGE" , "MiAlerta" , "MiAlerta_followUp" , "SE_C_Pregnancy" , "Pregnancy" , "MiAlta" , "Pregnancy_T3"]

def get_campaigns(client):
    return client.get_campaigns().all()

def get_events_by_name(campaign_name, temba_client):
    return temba_client.get_campaign_events(campaign=campaign_name).all()


def compare_events(event_list_io,
                   event_list_mx,
                   keys_to_validate=["delivery_hour","message","offset","unit"]):
    mistakes = {}
    if len(event_list_io) != len(event_list_mx):
        mistakes['La_longitud_no_coincide'] = {'mx': len(event_list_mx), 'io': len(event_list_io)}
        return mistakes
    io_sorted = sorted(event_list_io, key=lambda k: k.serialize()['flow']['name'])
    mx_sorted = sorted(event_list_mx, key=lambda k: k.serialize()['flow']['name'])

    for mx_event, io_event in zip(mx_sorted, io_sorted):
        mx_dict = mx_event.serialize()
        io_dict = io_event.serialize()
        for key in keys_to_validate:
            if mx_dict[key] != io_dict[key]:
                mistakes[key] = {"mx": mx_dict[key], "io": io_dict[key]}
        for key in io_dict['relative_to']:
            if mx_dict['relative_to'][key] != io_dict['relative_to'][key]:
                mistakes['relative_to'+key] = {"mx": mx_dict['relative_to'][key], "io": io_dict['relative_to'][key]}
        if mx_dict['flow']['name'] != io_dict['flow']['name']:
                mistakes['flow_name'] = {"mx": mx_dict['flow']['name'], "io": io_dict['flow']['name']}
    return mistakes


def main ():
    all_mistakes = {}
    all_flows = {}
    for campaign_name in CAMPAIGN_LIST:
        #We search the events in io domain
        event= get_events_by_name(campaign_name, io_client)
        flow_name = event[0].serialize()['campaign']['uuid']
        all_flows[flow_name] = 'foo'
    for key in  all_flows.keys():
        print key



main()
