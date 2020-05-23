$apps = 
    "vlc",
    "7zip",
    "1Password",
    "Blender",
    "DockerDesktop",
    "KeePass",
    "EpicGamesLauncher",
    "Evernote",
    "EarTrumpet",
    "Galaxy",
    "Git",
    "Chrome",
    "WindowsTerminal",
    "AzureCLI",
    "VisualStudioCode",
    "OBSStudio",
    "Signal",
    "Spotify",
    "Steam"
    "WhatsApp"
    "WinSCP",
    "qBittorrent",
    "Python",
    "OpenVPNConnect"

foreach ($app in $apps) {
    winget install $app
}