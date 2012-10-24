$SCRIPTPATH = "C:\Users\Dana\scripts"


# If Posh-Git environment is defined, load it.
if (test-path env:posh_git) {
    . $env:posh_git
      $env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"
      start-SshAgent -Quiet
}

set-alias vi "C:\Program Files (x86)\Vim\vim73\vim.exe"
set-alias vim "C:\Program Files (x86)\Vim\vim73\vim.exe"
set-alias gvim_exe "C:\program files (x86)\vim\vim73\gvim.exe"
set-alias edit "C:\Program Files (x86)\Notepad++\notepad++.exe"

$downloads = "C:\Users\dana\Downloads"
$docs = "C:\Users\dana\Documents"
$documents = "C:\Users\dana\Documents"
$code = "C:\ccm_wa\mkep01"
$github = "C:\Users\dana\Documents\GitHub"

#Github alias
function get-git_status {git status}
function get-git_checkout { git checkout }
function get-git_add { git add }

set-alias gs "get-git_status"
set-alias go "get-git_checkout"
set-alias ga "get-git_add"
#set-alias got "git "
#set-alias get "git "

set-alias vs "C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe" 


# for editing your PowerShell profile
Function Edit-Profile
{
    vim $profile
}

# for editing your Vim settings
Function Edit-Vimrc
{
    vim $home\_vimrc
}

# for editing your Vim settings
Function Edit-GitConfig
{
    vim $home\.gitconfig
}

# If an alias exists, remove it
if (test-path ALIAS:set) { remove-item ALIAS:set }

function set {
  if (-not $ARGS) {
    get-childitem ENV: | sort-object Name
    return
  }
  $myLine = $MYINVOCATION.Line
  $myName = $MYINVOCATION.InvocationName
  $myArgs = $myLine.Substring($myLine.IndexOf($myName) + $myName.Length + 1)
  $equalPos = $myArgs.IndexOf("=")
  # "=" character not found; output variables
  if ($equalPos -eq -1) {
    $result = get-childitem ENV: | where-object { $_.Name -like "$myArgs" } |
      sort-object Name
    if ($result) { $result } else { throw "Environment variable not found" }
  }
  # "=" character before end of string; set variable
  elseif ($equalPos -lt $myArgs.Length - 1) {
    $varName = $myArgs.Substring(0, $equalPos)
    $varData = $myArgs.Substring($equalPos + 1)
    set-item ENV:$varName $varData
  }
  # "=" character at end of string; remove variable
  else {
    $varName = $myArgs.Substring(0, $equalPos)
    if (test-path ENV:$varName) { remove-item ENV:$varName }
  }
}

function assetver {
  $result = get-childitem ENV: | grep SAR
  #echo $result
  
  $result=$result -split [char]13
  
  foreach ($asset in $result)
  {
      if($asset -contains "*v3.0*")
      {
        echo $asset
      }
  }
}

function assetver2 {
  $result = get-childitem ENV:
  echo $result
}

function vsh {
    param ($param)
    
    if ($param -eq $NULL) {
        “A solution was not specified, opening the first one found.”
        $solutions = get-childitem | ?{ $_.extension -eq “.sln” }
    }
    else {
        “Opening {0} …” -f $param
        vs $param
        break
    }
    if ($solutions.count -gt 1) {
        “Opening {0} …” -f $solutions[0].Name
        vs $solutions[0].Name
    }
    else {
        “Opening {0} …” -f $solutions.Name
        vs $solutions.Name
    }
}

# Always use one window for gvim from PS
function gvim {
    if ($args) {
        gvim_exe --remote-silent $args
    } else {
        gvim_exe
    }
}

function rm-rf {
    if ($args) {
        rm -re -fo $args
    }
}

function hosts {
    gvim_exe C:\Windows\system32\drivers\etc\hosts
}

function up {
    cd ..
}

#remove-item alias:ls
#set-alias ls Get-ChildItemColor

function Get-ChildItemColor {
    $fore = $Host.UI.RawUI.ForegroundColor
 
    Invoke-Expression ("Get-ChildItem $args") |
    %{
      if ($_.GetType().Name -eq 'DirectoryInfo') {
        $Host.UI.RawUI.ForegroundColor = 'White'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($_.Name -match '\.(zip|tar|gz|rar)$') {
        $Host.UI.RawUI.ForegroundColor = 'Blue'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($_.Name -match '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$') {
        $Host.UI.RawUI.ForegroundColor = 'Green'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($_.Name -match '\.(txt|cfg|conf|ini|csv|sql|xml|config)$') {
        $Host.UI.RawUI.ForegroundColor = 'Cyan'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($_.Name -match '\.(h|c|cpp|cs|asax|aspx.cs)$') {
        $Host.UI.RawUI.ForegroundColor = 'Yellow'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
       } elseif ($_.Name -match '\.(aspx|spark|master)$') {
        $Host.UI.RawUI.ForegroundColor = 'DarkYellow'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
       } elseif ($_.Name -match '\.(sln|csproj|vcproj)$') {
        $Host.UI.RawUI.ForegroundColor = 'Magenta'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
       }
        else {
        $Host.UI.RawUI.ForegroundColor = $fore
        echo $_
      }
    }
}

filter ColorWord( [string]$word, [ConsoleColor]$color ) {
    $later = $true
    $_ -split [regex]::Escape( $word ) | foreach {
      if( $later ) { Write-Host "$word" -NoNewline -ForegroundColor $color }
      else { $later = $true }
      Write-Host $_ -NoNewline
    }
    Write-Host
}