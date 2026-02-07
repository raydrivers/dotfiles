$env:EDITOR = "nvim"
$env:DOTFILES_DIR = "$HOME\dotfiles"
$env:PATH = "$HOME\.local\bin;$env:PATH"

Invoke-Expression (&starship init powershell)

if (Get-Command direnv -ErrorAction SilentlyContinue) {
    Invoke-Expression (direnv hook powershell | Out-String)
}
