# Exercicio Terraform - Solução

## Estrutura

- `modules/nginx-lb/`: Módulo Terraform reutilizável para criar EC2s, ELB e Security Group, parametrizado por ambiente/workspace.
- `main.tf`: Chama o módulo, define o backend remoto S3 e outputs.
- `variables.tf`: Variáveis globais para o root module.

## Como usar

1. **Inicialize o Terraform:**
   ```sh
   terraform init
   ```
2. **Selecione ou crie o workspace:**
   ```sh
   terraform workspace new dev
   terraform workspace new prod
   # ou para alternar
   terraform workspace select dev
   ```
3. **Ajuste variáveis se necessário** (em `variables.tf` ou via CLI).
4. **Aplique o plano:**
   ```sh
   terraform apply
   ```

## Estado Remoto
O backend S3 é configurado para usar um bucket e tabela DynamoDB distintos por workspace:
- Bucket: `fiap-cicd-tfstate-<workspace>`
- DynamoDB Table: `tfstate-lock-<workspace>`

## Nomenclatura
- Instâncias EC2: `nginx-<workspace>-<num>`
- ELB: `elb-<workspace>`
- Security Group: `allow-ssh-<workspace>`

## Ambientes
- Para criar ambientes diferentes, basta alternar o workspace do Terraform (`dev`, `prod`, etc).

## Submissão
- Compacte o conteúdo da pasta `Trabalho-final-solved` em um `.zip` e envie conforme instruções do exercício. 