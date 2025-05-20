### Dependências
# Padronização de código/commit

## Instalação rápida

- Execute `npm install -g commitizen; commitizen init cz-conventional-changelog --save-dev --save-exact`.
- Execute `npm install --save-dev prettier @commitlint/cli @commitlint/config-conventional lint-staged husky@8.0.0`.

## Roadmap

> ### prettier
> Padronizar a formatação de código
> 
> Execute `npm install --save-dev prettier`.
>
> Se não existir, crie o arquivo **prettierrc.js** e adicione:
```
module.exports = {
  "semi": true,// ; no final das linhas
  "singleQuote": true,// aspas simples ao invés de dupla
  "trailingComma": "all",// ; no final de objetos ex: const `obj = {}`;
  "tabWidth": 2,// número de espaços por identação
  "printWidth": 100,// a partir 100 caracteres a linha quebra
  "bracketSpacing": true,// espaço entre chave e valor de objetos
}
```
> #

> ### commitizen
> Execute `npm install -g commitizen`.
> 
> Comando para adicionar o config do commitizen no **package.json**.
> 
> Execute `commitizen init cz-conventional-changelog --save-dev --save-exact`.  
> No arquivo **commitlint.config.js** certifique-se de constar:
```
{
  ...scripts,
  "config": {
    "commitizen": {
      "path": "./node_modules/cz-conventional-changelog"
    }
  }
}
```
>
> #

> ### commitlint
> Execute `npm install --save-dev @commitlint/cli @commitlint/config-conventional`.  
> No arquivo **commitlint.config.js** certifique-se de constar:
```
module.exports = {
    extends: ['@commitlint/config-conventional']
}
```
>
> Obs:  
> Se estiver utilizando `husky`, certifique-se de que o seguinte trecho consta em **./husky/commit-msg**:
```
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx --no-install commitlint --edit "$1"
```
> Este trecho valida a mensagem do commit de acordo o padrão `Conventional Commits`.
> #

> ### lint-staged
> Roda comandos (Prettier, ESLint, etc) apenas nos **arquivos modificados** e adicionados ao `git` (staged).  
> Para instalar execute `npm install --save-dev lint-staged`.  
> Certifique-se de adicionar o seguinte trecho no **package.json**:
```
{
    ...scripts,
    "lint-staged": {
    "**/*.{js,json,css,md}": "prettier --write"
  }
}
```
> Obs:  
> Se estiver utilizando `husky`, certifique-se de que o seguinte trecho consta em **./husky/pre-commit**:
```
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx lint-staged
```
> Este trecho garante a execução de `lint-staged` antes da criação do commit.
> #

> ### husky
> 
> Execute `npx install -save-dev husky@8.0.0`.  
> Adicione o `"husky install"` em **scripts.prepare**.  
> Execute `npx husky install`.  
> Mantenha os arquivos **commit-msg** e **pre-commit** em **./husky/**.  
> Mantenha os arquivos **.gitignore**, **h** e **husky.sh** em **./husky/_/**.  
> O restante pode apagar se não for usar.
> #