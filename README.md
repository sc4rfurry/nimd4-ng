![Made with love in Nim](https://madewithlove.now.sh/pk?heart=true&template=for-the-badge&text=Nim)
# Nimd4-ng

A blazing fast yet compact port scanner written in nim.

### 🔧 Technologies & Tools

![](https://img.shields.io/badge/OS-Linux-informational?style=flat-square&logo=kali-linux&logoColor=white&color=5194f0&bgcolor=110d17)
![](https://img.shields.io/badge/Editor-VS_Code-informational?style=flat-square&logo=visual-studio&logoColor=white&color=5194f0)
![](https://img.shields.io/badge/Language-Nim-informational?style=flat-square&logo=nim&logoColor=white&color=5194f0&bgcolor=110d17)
![](https://img.shields.io/badge/Nim_Version-1.6.10-informational?style=flat-square&logo=Nim&logoColor=white&color=5194f0&bgcolor=110d17)
##

### 📚 Requirements (For Development Purpose)
> - [**Nim**](https://nim-lang.org/) 1.6.10

## Features

- Scan single port, Port range and all 65535 ports.
- For convenience you can scan for Common top 1002 ports .
- the Linux and Windows binaries are less then 100kb.
- User Friendly. :xD

>> `!Note`: If you are using Command Prompt for running the tools it might messed up the colors so it is advised to use **Windows Terminal** rather than command prompt.

## Usage
> For usage or help
```bash
./nimd4 -h/--help
```
![Img](https://i.ibb.co/Lp0sm4D/help.png "Help")

> For single port scanning.
```bash
./nimd4 -t scanme.nmap.org -p 80
```

![Img](https://i.ibb.co/t3bVRvk/port-scan.png "Single Port Scan")

> For Range of ports
```bash
./nimd4 -t scanme.nmap.org -r 1-100
```

![Img](https://i.ibb.co/PzdB5Hk/port-range.png "Port Range")

> Common Ports (1002)

![Img](https://i.ibb.co/DgFSY6S/Common-Ports.png "Port Range")
##

## Binaries
<a href="https://github.com/sc4rfurry/nimd4-ng/releases/" style="text-align=center"><img src="https://img.shields.io/github/release/sc4rfurry/nimd4-ng?include_prereleases=&sort=semver&color=blue" alt="GitHub release"></a>

> - You can download the pre-built binaries [Binries](https://github.com/sc4rfurry/nimd4-ng/releases) here.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)