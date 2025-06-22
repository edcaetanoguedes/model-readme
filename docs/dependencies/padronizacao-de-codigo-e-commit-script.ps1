# Instalando dependências
npm install --save-dev commitizen prettier @commitlint/cli @commitlint/config-conventional lint-staged husky@8.0.0
npx commitizen init cz-conventional-changelog --save-dev --save-exact

# COMMITIZEN e LINT_STAGED

# Caminho do arquivo package.json
$packageJsonPath = "package.json"

# Verifica se o arquivo existe
if (-Not (Test-Path $packageJsonPath)) {
    Write-Host "O arquivo package.json não foi encontrado."
    exit 1
}

# Lê o conteúdo do JSON
$json = Get-Content $packageJsonPath -Raw | ConvertFrom-Json

# Cria os objetos de configuração, se necessário
if (-not $json.config) {
    $json | Add-Member -MemberType NoteProperty -Name config -Value (@{})
}

# Define o bloco commitizen
$commitizenPath = "./node_modules/cz-conventional-changelog"
$json.config.commitizen = @{ path = $commitizenPath }

# Cria os objetos de configuração, se necessário
if (-not $json."lint-staged") {
    $json | Add-Member -MemberType NoteProperty -Name "lint-staged" -Value (@{})
}

# Adiciona ou atualiza a seção "lint-staged"
$json."lint-staged" = @{
    "**/*" = "prettier --write --ignore-unknown"
}

# Converte de volta para JSON formatado
$jsonFormatado = $json | ConvertTo-Json -Depth 10

# Salva de volta no package.json
Set-Content -Path $packageJsonPath -Value $jsonFormatado -Encoding UTF8

Write-Host "Bloco 'config.commitizen' adicionado ao package.json com sucesso!"

# PRETTIER

##  Caminho do arquivo
$prettier_config = "prettierrc.js"

## Conteúdo do arquivo prettierrc
$conteudo = @"
module.exports = {
  "semi": true, // ; no final das linhas
  "singleQuote": true, // aspas simples ao invés de dupla
  "trailingComma": "all", // ; no final de objetos ex: const `obj = {}`;
  "tabWidth": 2, // número de espaços por identação
  "printWidth": 100, // a partir 100 caracteres a linha quebra
  "bracketSpacing": true, // espaço entre chave e valor de objetos
}
"@

# Criar o arquivo com o conteúdo
Set-Content -Path $prettier_config -Value $conteudo -Encoding UTF8

if (Test-Path $prettier_config) {
    Write-Host "Task: Arquivo '$prettier_config' criado/configurado com sucesso!"
} else {
    Write-Host "O arquivo '$prettier_config' NÃO foi criada!"
}

# COMMITLINT

# Define o nome do arquivo
$commitlint_config = "commitlint.config.js"

# Define o conteúdo
$conteudo = @"
module.exports = {
    extends: ['@commitlint/config-conventional']
}
"@

# Cria o arquivo com o conteúdo
Set-Content -Path $commitlint_config -Value $conteudo -Encoding UTF8

if (Test-Path $commitlint_config) {
    Write-Host "Task: Arquivo '$commitlint_config' criado/configurado com sucesso!"
} else {
    Write-Host "O arquivo '$commitlint_config' NÃO foi criada!"
}

# HUSKY

# Executa o comando para instalar o Husky
npx husky install

if (Test-Path ".husky") {
    Write-Host "A pasta '.husky' foi criada com sucesso!"

    # Cria o arquivo commit-msg dentro da pasta .husky
    $hookPath = ".husky\commit-msg"
    $hookContent = @'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx --no-install commitlint --edit "$1"
'@
    Set-Content -Path $hookPath -Value $hookContent -Encoding UTF8
    Write-Host "Hook 'commit-msg' criado com sucesso em .husky\commit-msg"

    # Cria o arquivo pre-commit dentro da pasta .husky
    $hookPath = ".husky\pre-commit"
    $hookContent = @'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx lint-staged
'@
    Set-Content -Path $hookPath -Value $hookContent -Encoding UTF8
    Write-Host "Hook 'commit-msg' criado com sucesso em .husky\commit-msg"
} else {
    Write-Host "A pasta '.husky' NÃO foi criada. Verifique se o comando 'npx husky install' foi executado corretamente."
}
