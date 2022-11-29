import pure/strutils
import std/net
import os
import strformat


let
    red = "\e[31m"
    yellow = "\e[33m"
    cyan = "\e[36m"
    green = "\e[32m"
    blue = "\e[34m"
    bg_red = "\e[41m"
    bg_blue = "\e[44m"
    bold = "\e[1m"
    underline = "\e[21m"
    def = "\e[0m"


proc banner() =
    var banner: string = """
             _       _________ _______  ______      ___           _        _______ 
            ( (    /|\__   __/(       )(  __  \    /   )         ( (    /|(  ____ \
            |  \  ( |   ) (   | () () || (  \  )  / /) |         |  \  ( || (    \/
            |   \ | |   | |   | || || || |   ) | / (_) (_  _____ |   \ | || |      
            | (\ \) |   | |   | |(_)| || |   | |(____   _)(_____)| (\ \) || | ____ 
            | | \   |   | |   | |   | || |   ) |     ) (         | | \   || | \_  )
            | )  \  |___) (___| )   ( || (__/  )     | |         | )  \  || (___) |
            |/    )_)\_______/|/     \|(______/      (_)         |/    )_)(_______)
                
    """
    echo fmt"{yellow}{banner}{def}"
    echo fmt"""
                    {bold}{bg_red}  Nimd4-ng  {def}  --  {bold}{bg_blue} A Simple Port Scanner Written in Nim. {def}
                            
                            {green}Author:{def}     sc4rfurry
                            {green}Version:{def}    1.0
                            {underline}{green}Github{def}:     https://github.com/sc4rfurry
    """
    echo fmt"{bold}{yellow}================================================================================================{def}"
    echo "\n"

proc help() =
    echo fmt"""
    {green}Usage:{def} {yellow}{bold}./nimd4{def} {bold}[options]{def}
    
    {cyan}Options{def}:
        {red}Required{def}:
            -t, --host <host>               Host or IP to scan
            -p, --port <port>               Port to scan
        {yellow}Optional{def}:
            -h, --help                      Show this help
            -r, --range <port-range>        Port range to scan (Example: 20-1024)
            --all                           Scan all ports (1-65535)
            -cp, --common-ports             Scan Most Common ports
    
    {cyan}Examples{def}:
        {yellow}./nimd4{def} {bold}-t scanme.nmap.org -p 80{def}
        {yellow}./nimd4{def} {bold}-t scanme.nmap.org -r 20-1024{def}
        {yellow}./nimd4{def} {bold}-t scanme.nmap.org --all{def}
        {yellow}./nimd4{def} {bold}-t scanme.nmap.org -cp{def}
        """
    quit(0)


let commonPorts: array[1002, int] = [
    5601, 9300, 80, 23, 443, 21, 22, 25, 3389, 110, 445, 139, 143, 53, 135, 3306, 8080, 1723, 111,
    995, 993, 5900, 1025, 587, 8888, 199, 1720, 465, 548, 113, 81, 6001, 10000, 514, 5060, 179,
    1026, 2000, 8443, 8000, 32768, 554, 26, 1433, 49152, 2001, 515, 8008, 49154, 1027, 5666, 646,
    5000, 5631, 631, 49153, 8081, 2049, 88, 79, 5800, 106, 2121, 1110, 49155, 6000, 513, 990, 5357,
    427, 49156, 543, 544, 5101, 144, 7, 389, 8009, 3128, 444, 9999, 5009, 7070, 5190, 3000, 5432,
    1900, 3986, 13, 1029, 9, 5051, 6646, 49157, 1028, 873, 1755, 2717, 4899, 9100, 119, 37, 1000,
    3001, 5001, 82, 10010, 1030, 9090, 2107, 1024, 2103, 6004, 1801, 5050, 19, 8031, 1041, 255,
    2967, 1049, 1048, 1053, 3703, 1056, 1065, 1064, 1054, 17, 808, 3689, 1031, 1044, 1071, 5901,
    9102, 100, 8010, 2869, 1039, 5120, 4001, 9000, 2105, 636, 1038, 2601, 7000, 1, 1066, 1069, 625,
    311, 280, 254, 4000, 5003, 1761, 2002, 2005, 1998, 1032, 1050, 6112, 3690, 1521, 2161, 6002,
    1080, 2401, 4045, 902, 7937, 787, 1058, 2383, 32771, 1033, 1040, 1059, 50000, 5555, 10001,
    1494, 2301, 593, 3, 3268, 7938, 1234, 1022, 1035, 9001, 1074, 8002, 1036, 1037, 464, 1935,
    6666, 2003, 497, 6543, 1352, 24, 3269, 1111, 407, 500, 20, 2006, 3260, 1034, 15000, 1218, 4444,
    264, 2004, 33, 1042, 42510, 999, 3052, 1023, 1068, 222, 888, 7100, 563, 1717, 2008, 992, 32770,
    32772, 7001, 8082, 2007, 5550, 2009, 1043, 512, 5801, 7019, 2701, 50001, 1700, 4662, 2065,
    2010, 42, 9535, 2602, 3333, 161, 5100, 2604, 4002, 5002, 8192, 6789, 8194, 6059, 1047, 8193,
    2702, 9595, 1051, 9594, 9593, 16993, 16992, 5226, 5225, 32769, 1052, 1055, 3283, 1062, 9415,
    8701, 8652, 8651, 8089, 65389, 65000, 64680, 64623, 55600, 55555, 52869, 35500, 33354, 23502,
    20828, 1311, 1060, 4443, 1067, 13782, 5902, 366, 9050, 1002, 85, 5500, 1864, 5431, 1863, 8085,
    51103, 49999, 45100, 10243, 49, 6667, 90, 27000, 1503, 6881, 8021, 1500, 340, 5566, 8088, 2222,
    9071, 8899, 1501, 5102, 32774, 32773, 9101, 6005, 9876, 5679, 163, 648, 146, 1666, 901, 83,
    9207, 8001, 8083, 5004, 3476, 8084, 5214, 14238, 12345, 912, 30, 2605, 2030, 6, 541, 8007,
    3005, 4, 1248, 2500, 880, 306, 4242, 1097, 9009, 2525, 1086, 1088, 8291, 52822, 6101, 900,
    7200, 2809, 800, 32775, 12000, 1083, 211, 987, 705, 20005, 711, 13783, 6969, 3071, 3801, 3017,
    8873, 5269, 5222, 1046, 1085, 5987, 5989, 5988, 2190, 11967, 8600, 8087, 30000, 9010, 7741,
    3367, 3766, 7627, 14000, 3031, 1099, 1098, 6580, 2718, 15002, 4129, 6901, 3827, 3580, 2144,
    8181, 9900, 1718, 9080, 2135, 2811, 1045, 2399, 1148, 10002, 9002, 8086, 3998, 2607, 11110,
    4126, 2875, 5718, 9011, 5911, 5910, 9618, 2381, 1096, 3300, 3351, 1073, 8333, 15660, 6123,
    3784, 5633, 3211, 1078, 3659, 3551, 2100, 16001, 3325, 3323, 2260, 2160, 1104, 9968, 9503,
    9502, 9485, 9290, 9220, 8994, 8649, 8222, 7911, 7625, 7106, 65129, 63331, 6156, 6129, 60020,
    5962, 5961, 5960, 5959, 5925, 5877, 5825, 5810, 58080, 57294, 50800, 50006, 50003, 49160,
    49159, 49158, 48080, 40193, 34573, 34572, 34571, 3404, 33899, 3301, 32782, 32781, 31038, 30718,
    28201, 27715, 25734, 24800, 22939, 21571, 20221, 20031, 19842, 19801, 19101, 17988, 1783,
    16018, 16016, 15003, 14442, 13456, 10629, 10628, 10626, 10621, 10617, 10616, 10566, 10025,
    10024, 10012, 1169, 5030, 5414, 1057, 6788, 1947, 1094, 1075, 1108, 4003, 1081, 1093, 4449,
    1687, 1840, 1100, 1063, 1061, 1107, 1106, 9500, 20222, 7778, 1077, 1310, 2119, 2492, 1070,
    20000, 8400, 1272, 6389, 7777, 1072, 1079, 1082, 8402, 691, 89, 32776, 1999, 1001, 212, 2020,
    7002, 2998, 6003, 50002, 3372, 898, 5510, 32, 2033, 5903, 99, 749, 425, 43, 5405, 6106, 13722,
    6502, 7007, 458, 1580, 9666, 8100, 3737, 5298, 1152, 8090, 2191, 3011, 5200, 3851, 3371, 3370,
    3369, 7402, 5054, 3918, 3077, 7443, 3493, 3828, 1186, 2179, 1183, 19315, 19283, 5963, 3995,
    1124, 8500, 1089, 10004, 2251, 1087, 5280, 3871, 3030, 62078, 9091, 4111, 1334, 3261, 2522,
    5859, 1247, 9944, 9943, 9877, 9110, 8654, 8254, 8180, 8011, 7512, 7435, 7103, 61900, 61532,
    5922, 5915, 5904, 5822, 56738, 55055, 51493, 50636, 50389, 49175, 49165, 49163, 3546, 32784,
    27355, 27353, 27352, 24444, 19780, 18988, 16012, 15742, 10778, 4006, 2126, 4446, 3880, 1782,
    1296, 9998, 32777, 9040, 32779, 1021, 2021, 666, 32778, 616, 700, 1524, 1112, 5802, 4321, 545,
    49400, 84, 38292, 2040, 3006, 2111, 32780, 1084, 1600, 2048, 2638, 9111, 6547, 6699, 16080,
    2106, 667, 6007, 1533, 5560, 1443, 720, 2034, 555, 801, 3826, 3814, 7676, 3869, 1138, 6567,
    10003, 3221, 6025, 2608, 9200, 7025, 11111, 4279, 3527, 1151, 8300, 6689, 9878, 8200, 10009,
    8800, 5730, 2394, 2393, 2725, 5061, 6566, 9081, 5678, 3800, 4550, 5080, 1201, 3168, 1862, 1114,
    3905, 6510, 8383, 3914, 3971, 3809, 5033, 3517, 4900, 9418, 2909, 3878, 8042, 1091, 1090, 3920,
    3945, 1175, 3390, 3889, 1131, 8292, 1119, 5087, 7800, 4848, 16000, 3324, 3322, 1117, 5221,
    4445, 9917, 9575, 9099, 9003, 8290, 8099, 8093, 8045, 7921, 7920, 7496, 6839, 6792, 6779, 6692,
    6565, 60443, 5952, 5950, 5907, 5906, 5862, 5850, 5815, 5811, 57797, 56737, 5544, 55056, 5440,
    54328, 54045, 52848, 52673, 50500, 50300, 49176, 49167, 49161, 44501, 44176, 41511, 40911,
    32785, 32783, 30951, 27356, 26214, 25735, 19350, 18101, 18040, 17877, 16113, 15004, 14441,
    12265, 12174, 10215, 10180, 4567, 6100, 4004, 4005, 8022, 9898, 7999, 1271, 1199, 3003, 1122,
    2323, 2022, 4224, 617, 777, 417, 714, 6346, 981, 722, 1009, 4998, 70, 1076, 5999, 10082, 765,
    301, 524, 668, 2041, 259, 1984, 2068, 6009, 1417, 1434, 44443, 7004, 1007, 4343, 416, 2038,
    4125, 1461, 9103, 6006, 109, 911, 726, 1010, 2046, 2035, 7201, 687, 2013, 481, 903, 125, 6669,
    6668, 1455, 683, 1011, 2043, 2047, 256, 31337, 9929, 5998, 406, 44442, 783, 843, 2042, 2045,
    1875, 1556, 5938, 8675, 1277, 3972, 3968, 3870, 6068, 3050, 5151, 3792, 8889, 5063, 1198, 1192,
    4040, 1145, 6060, 6051, 3916, 7272, 9443, 9444, 7024, 13724, 4252, 4200, 1141, 1233, 8765,
    3963, 1137, 9191, 3808, 8686, 3981, 9988, 1163, 4164, 3820, 6481, 3731, 40000, 2710, 3852,
    3849, 3853, 5081, 8097, 3944, 1287, 3863, 4555, 4430, 7744, 1812, 7913, 1166, 1164, 1165,
    10160, 8019, 4658, 7878, 1259, 1092, 10008, 3304, 3307,
]



proc main(commonPorts: array[1002, int]) =
    let numParams = paramCount()
    var
        host: string
        port: int 
        port_range: seq[string]
        all_ports: int = 65535
    var isAllPorts: bool = false
    var isRange: bool = false
    var isCommon: bool = false
    if numParams < 3:
        banner()
        help()
    else:
        if numParams == 4:
            for param in 1..numParams:
                if paramStr(param) == "-t" or paramStr(param) == "--host":
                    host = paramStr(param + 1)
                elif paramStr(param) == "-p" or paramStr(param) == "--port":
                    port = (paramStr(param + 1)).parseInt()
                elif paramStr(param) == "-r" or paramStr(param) == "--range":
                    var p_range: string = paramStr(param + 1)
                    port_range = (p_range.split("-"))
                    isRange = true
                elif paramStr(param) == "-h" or paramStr(param) == "--help":
                    banner()
                    help()
                else:
                    discard
        elif numParams == 3:
            for param in 1..numParams:
                if paramStr(param) == "-t" or paramStr(param) == "--host":
                    host = paramStr(param + 1)
                elif paramStr(param) == "--all":
                    isAllPorts = true
                elif paramStr(param) == "-cp" or paramStr(param) == "--common-ports":
                    isCommon = true
                elif paramStr(param) == "-h" or paramStr(param) == "--help":
                    echo "Banner"
                    echo "Help Menu"
                else:
                    discard

    
    
    banner()
    
    echo fmt"""
                {blue}*******************{def} {bold}{yellow}Config{def} {blue}********************{def}
                {blue}|{def}        {bold}{green}Host{def}:         {host}
                {blue}|{def}        {bold}{green}Port{def}:         {port}
                {blue}|{def}        {bold}{green}Timeout{def}:      3sec
                {blue}|{def}        {bold}{green}Range{def}:        {isRange}
                {blue}|{def}        {bold}{green}All Ports{def}:    {isAllPorts}
                {blue}|{def}        {bold}{green}Common Ports{def}: {isCommon}
                {blue}***********************************************{def}
    """
    
    if isAllPorts:
        try:
            echo fmt"""{yellow}Warning{def} - Scanning all ports can take a long time."""
            write(stdout, "Are you sure you want to continue? (y/n): ")
            var answer = readLine(stdin)
            if answer == "y" or answer == "Y":
                for port in 1..all_ports:
                    try:
                        let sok: Socket = newSocket(AF_INET, SOCK_STREAM, IPPROTO_IP)
                        connect(sok, host, Port(port), 3024)
                        echo fmt"{blue}Port{def} {port} {green}is open{def}"
                        sok.close()
                    except:
                        discard
            else:
                echo "Exiting..."
                quit(0)        
        except Exception as e:
            echo fmt"{bg_red}{e.msg}{def}"
            quit(1)
    elif isCommon:
            try:
                for port in commonPorts:
                    try:
                        let sok: Socket = newSocket(AF_INET, SOCK_STREAM, IPPROTO_IP)
                        connect(sok, host, Port(port), 3024)
                        echo fmt"{blue}Port{def} {port} {green}is open{def}"
                        sok.close()
                    except:
                        discard
            except Exception as e:
                echo fmt"{bg_red}{e.msg}{def}"
                quit(1)
    elif isRange:
            try:
                for port in port_range[0].parseInt()..port_range[1].parseInt():
                    try:
                        let sok: Socket = newSocket(AF_INET, SOCK_STREAM, IPPROTO_IP)
                        connect(sok, host, Port(port), 3024)
                        echo fmt"{blue}Port{def} {port} {green}is open{def}"
                        sok.close()
                    except:
                        discard
            except Exception as e:
                echo fmt"{bg_red}{e.msg}{def}"
                quit(1)
    else:
        try:
            let sok: Socket = newSocket(AF_INET, SOCK_STREAM, IPPROTO_IP)
            connect(sok, host, Port(port), 3024)
            echo fmt"{blue}Port{def} {port} {green}is open{def}"
            sok.close()
        except Exception as e:
            echo fmt"{blue}Port{def} {port} {red}is closed{def}"
            echo fmt"{bg_red}{e.msg}{def}"
            quit(1)




when isMainModule:
    main(commonPorts)