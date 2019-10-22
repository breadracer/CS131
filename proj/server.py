# Allocated ports on seasnet servers: 12282-12290
import asyncio
import aiohttp
import copy
import json
import time
import sys

base_url = 'https://maps.googleapis.com/maps/api/place/nearbysearch'
API_KEY = 'AIzaSyCan3J0ED6NC5wX7hR6cNAUZ0AqZLoetGs'

servers = {
    'Goloman':{
        'neighbors': ['Hands', 'Holiday', 'Wilkes'],
        'port': 12282
    },
    'Hands':{
        'neighbors': ['Goloman', 'Wilkes'],
        'port': 12283
    },
    'Holiday':{
        'neighbors': ['Goloman', 'Welsh', 'Wilkes'],
        'port': 12284
    },
    'Welsh':{
        'neighbors': ['Holiday'],
        'port': 12285
    },
    'Wilkes':{
        'neighbors': ['Goloman', 'Hands', 'Holiday'],
        'port': 12286
    }
}

client_locations = {}

f = ''

def get_lat_lng(string):
    pair = string.replace('+', ' ').replace('-', ' -').strip().split(' ')
    return '%.7f' % float(pair[0]), '%.7f' % float(pair[1])

async def get_available_servers():
    availables = []
    for server in servers:
        if server != sys.argv[1]:
            try:
                reader, writer = await asyncio.open_connection(
                    '127.0.0.1', servers[server]['port'])
                f.write('Sent "TEST" to {}\n'.format(server))
                f.flush()
                writer.write('TEST'.encode())
                writer.write_eof()
                res = await reader.read()
                f.write('Received "{}" from {}\n'.format(res.decode(), server))
                f.flush()
                await writer.drain()
                writer.close()
                availables.append(server)
            except:
                f.write('Test connection with {} failed\n'.format(server))
                f.flush()
    return availables

def construct_flood_tree(parent, flooded, availables):
    node = {}
    if parent not in flooded:
        flooded.append(parent)
    flooded.sort()
    if flooded == availables:
        return node
    for neighbor in servers[parent]['neighbors']:
        if neighbor not in flooded and neighbor in availables:
            flooded.append(neighbor)
            node[neighbor] = {}
    for neighbor in node:
        node[neighbor] = construct_flood_tree(neighbor, flooded, availables)
    return node

async def handle_iamat(addr, argv):
    server = sys.argv[1]
    timestamp = argv[3]

    time_diff = '%.9f' % (time.time() - float(timestamp))
    time_diff = '+' + time_diff if float(time_diff) > 0 else time_diff
    client_locations[argv[1]] = {
        'location': argv[2],
        'timestamp': timestamp,
        'time_diff': time_diff
    }
    
    availables = await get_available_servers()
    flood_tree = construct_flood_tree(server, [], availables)
    
    for neighbor in flood_tree:
        try:
            reader, writer = await asyncio.open_connection(
                '127.0.0.1', servers[neighbor]['port'])
            req_text = ' '.join(['FLOOD', time_diff, *argv[1:],
                                 json.dumps(flood_tree).replace(' ', ''), neighbor])
            f.write('Sent "{}" to {}\n'.format(req_text, neighbor))
            f.flush()
            writer.write(req_text.encode())
            writer.write_eof()
            res = await reader.read()
            f.write('Received "{}" from {}\n'.format(res.decode(), neighbor))
            f.flush()
            await writer.drain()
            f.write('Close the connection with ' + neighbor + '\n')
            f.flush()
            writer.close()
        except:
            f.write('Connection to {} failed\n'.format(neighbor))
            f.flush()
    
    return ' '.join(['AT', server, time_diff, *argv[1:]])

async def handle_whatsat(addr, argv):
    server = sys.argv[1]
    client = argv[1]
    if client not in client_locations:
        f.write('Record not found for client "{}"\n'.format(client))
        f.flush()
        return 'Record not found'
    location = client_locations[client]['location']
    lat, lng = get_lat_lng(location)
    location_str = lat + ',' + lng
    
    timestamp = client_locations[client]['timestamp']
    time_diff = client_locations[client]['time_diff']
    radius = int(argv[2]) * 1000
    max_results = int(argv[3])
    
    if radius > 50000 or radius <= 0 or max_results > 20 or max_results <= 0:
        f.write('Invalid radius or upper bound\n')
        f.flush()
        return 'Invalid radius or upper bound'

    url = '{}/json?location={}&radius={}&key={}'.format(base_url,
                                                        location_str, radius, API_KEY)
    res = None
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            res = await response.json()

    if len(res['results']) > max_results:
        res['results'] = res['results'][:max_results]
        
    at_message = ' '.join(['AT', server, time_diff, client, location, timestamp])
    return at_message + '\n' + json.dumps(res) + '\n\n'

async def handle_flood(addr, argv):
    server = sys.argv[1]
    client_locations[argv[2]] = {
        'location': argv[3],
        'timestamp': argv[4],
        'time_diff': argv[1]
    }
    
    flood_tree = json.loads(argv[5])
    parents = argv[6:]

    curr = copy.deepcopy(flood_tree)
    for node in parents:
        curr = curr[node]

    children = list(curr.keys())    
    for child in children:
        try:
            reader, writer = await asyncio.open_connection(
                '127.0.0.1', servers[child]['port'])
            req_text = ' '.join(['FLOOD', *argv[1:], child])
            f.write('Sent "{}" to {}\n'.format(req_text, child))
            f.flush()
            writer.write(req_text.encode())
            writer.write_eof()
            res = await reader.read()
            f.write('Received "{}" from {}\n'.format(res.decode(), child))
            f.flush()
            await writer.drain()
            f.write('Close the connection with ' + child + '\n')
            f.flush()
            writer.close()
        except:
            f.write('Test connection with {}: failed\n'.format(child))
            f.flush()
    return 'FLOOD succeeded'

async def handle_test(addr, argv):
    return 'SUCCESS'

command_handlers = {
    'IAMAT': handle_iamat,
    'WHATSAT': handle_whatsat,
    'FLOOD': handle_flood,
    'TEST': handle_test
}

async def handle_requests(reader, writer):
    req = await reader.read()
    req_text = req.decode()
    addr = writer.get_extra_info('peername')
    f.write('Received "{}" from {} {}\n'.format(req_text, *addr))
    f.flush()    
    argv = req_text.split()
    res_text = ''
    if argv[0] not in command_handlers:
        res_text = '? ' + req_text
    else:
        res_text = await command_handlers[argv[0]](addr, argv)
        
    f.write('Sent "{}" to {} {}\n'.format(res_text, *addr))
    f.flush()
    writer.write(res_text.encode())
    writer.write_eof()
    await writer.drain()
    f.write('Close the connection with {} {}\n'.format(*addr))
    f.flush()
    writer.close()

async def main():
    global f
    f = open('{}.log'.format(sys.argv[1]), 'w+')
    server = await asyncio.start_server(
        handle_requests, '127.0.0.1', servers[sys.argv[1]]['port'])
    address = server.sockets[0].getsockname()
    print('Serving on {} {}'.format(*address))
    f.write('Serving on {} {}\n'.format(*address))
    f.flush()
    async with server:
        await server.serve_forever()
    f.close()
        
if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Bad arguments', file=sys.stderr)
    elif sys.argv[1] not in servers:
        print('Unknown server name: {}'.format(sys.argv[1]), file=sys.stderr)
    else:
        asyncio.run(main())
