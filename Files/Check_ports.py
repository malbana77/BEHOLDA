#!/usr/bin/env python
import nmap
import optparse
import socket
import subprocess
import nmap3


def get_arguments():
    parser = optparse.OptionParser()
    # Handling Command-line Arguments
    parser.add_option("-t", "--target", dest="target", help="Target IP")
    (options, arguments) = parser.parse_args()
    if not options.target:
        #Code to handle error
        parser.error("[-] Please specify an target, use --help for more info.")
    return options

options = get_arguments()
nm = nmap.PortScanner()
tar = options.target
nnmap = nmap3.Nmap()
# Add Banner

def isOpen(ip, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:

        s.connect((ip, int(port)))
        
        s.shutdown(2)
        return True
    except:
        return False

# COMMAND = "ping " + format(tar) + " -w 5 | grep 'received' | cut -d ',' -f 2 | cut -d ' ' -f 2 | sed -n 1p"
# rr = (subprocess.call(COMMAND, shell=True))
output = subprocess.check_output("ping " + format(tar) + " -w 5 | grep 'received' | cut -d ',' -f 2 | cut -d ' ' -f 2 | sed -n 1,1p", shell=True)

f = open(".scan.txt", "a")
version_result = nnmap.nmap_version_detection(tar)
f.write(format(version_result))
nm = nmap.PortScanner()
machine = nm.scan(format(tar), arguments='-O')
try:
        os = machine['scan'][format(tar)]['osmatch'][0]['osclass'][0]['osfamily']
        f.write("\n")
        f.write('OpSy:' + format(os))
except IndexError:
        print ("error")
        exit()
except KeyError:
        print ("error")
        exit()

f.close()
n = str(5)


