choco install googlechrome 7zip vscode lightshot.install puntoswitcher


$Destination = 'C:\old-games\dos\'
$patternUrlFile = '<a class="gamelink" href="(.*)">Скачать файл'

#1 создание словаря
$hash = @{ 
    Doom  = 8976;
    Doom2 = 91
}


$WebClient = New-Object System.Net.WebClient
New-Item $Destination -Force

function Load {
    
    Param ($Url, $Name)

    $WebClient.DownloadFile($Url,$Name) 
    & ${env:ProgramFiles}\7-Zip\7z.exe x "$Destination$Name" "-o$($Destination)" -y
}

function Get-UrlFile {
    
    Param ($FileId, $Name)

    $src = $WebClient.DownloadString("https://www.old-games.ru/game/download/get.php?fileid=$FileId")
    #regex
    $src -match $patternUrlFile
    return $matches[1]
}

$hash.Keys | ForEach-Object {
    $a = Get-UrlFile $hash[$_] $_
    Load $a $_
}


Load "https://dl.old-games.su/get/gw9byXBLUtfYZSQXjhyBeQ==,1629021744/pc/doom/files/Doom.rar" doom.rar


#получение ссылки на игру (файл айди завернуть в переменную можно в словарике айди-нейм игры)

$patternA = '<a class="gamelink" href="'
$indA = $src.IndexOf($patternA)
$indB = $src.IndexOf('">Скачать файл')
$indStart = $indA+$patternA.Length
$src.Substring($indStart,$indB-$indStart)


Load 
#распаковка
$Zips = Get-ChildItem -filter "*.rar" -path A:\testfolder\ 

$WinRar = "${env:ProgramFiles}\7-Zip\7z.exe"

foreach ($zip in $Zips)
{
& $WinRar x $zip.FullName $Destination
#Get-Process winrar | Wait-Process
}