import asyncio
import time
import sys


server_ports = {
    'Goloman': 12282,
    'Hands': 12283,
    'Holiday': 12284,
    'Welsh': 12285,
    'Wilkes': 12286
}

async def tcp_echo_client(argv):
    server = argv[0]
    command = argv[1:]
    if command[0] == 'IAMAT':
        command.append('%.9f' % time.time())
    try:
        reader, writer = await asyncio.open_connection('127.0.0.1', server_ports[server])
        message = ' '.join(command)
        print('Send: {}'.format(message))
        writer.write(message.encode())
        writer.write_eof()

        data = await reader.read()
        print('Received: {}'.format(data.decode()))

        print('Close the connection')
        writer.close()
        
    except:
        print('Connection failed', file=sys.stderr)

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Bad arguments', file=sys.stderr)    
    else:
        asyncio.run(tcp_echo_client(sys.argv[1:]))
