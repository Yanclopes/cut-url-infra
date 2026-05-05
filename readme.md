## Visão Geral da Arquitetura

A estrutura provisiona uma rede virtual privada (VPC) distribuída em duas zonas de disponibilidade, um balanceador de carga, instâncias auto-executáveis e um banco de dados relacional.

### Componentes de Rede
* **VPC:** Rede isolada com suporte a DNS hostnames.
* **Subnets:** Duas subnets públicas localizadas em zonas de disponibilidade distintas (us-east-1a e us-east-1b) para garantir que o Application Load Balancer (ALB) opere em conformidade com os requisitos de alta disponibilidade da AWS.
* **Internet Gateway (IGW):** Permite a comunicação entre os recursos da VPC e a internet.
* **Tabelas de Roteamento:** Configurações que direcionam o tráfego de saída das subnets para o IGW.

### Camada de Segurança (Security Groups)
* **Web Security Group:** Permite tráfego de entrada na porta 80 (HTTP).
* **Database Security Group:** Camada de proteção para o banco de dados que aceita conexões na porta 5432 apenas se a origem for o Web Security Group, impedindo exposição direta à internet.

### Camada de Aplicação e Escalabilidade
* **Application Load Balancer (ALB):** Atua como ponto único de entrada, distribuindo o tráfego entre as instâncias do Auto Scaling Group.
* **Launch Template:** Define a configuração das instâncias EC2, incluindo a AMI, tipo de instância e o script de inicialização (User Data).
* **Auto Scaling Group (ASG):** Gerencia o ciclo de vida das instâncias, garantindo que o número desejado de réplicas esteja sempre ativo e realizando substituições automáticas em caso de falha.

### Banco de Dados
* **Amazon RDS (PostgreSQL):** Instância gerenciada utilizando a classe db.t3.micro.
* **DB Subnet Group:** Define em quais subnets o banco de dados pode ser alocado para manter a conectividade com a aplicação.

---

## Script de Inicialização (User Data)

O provisionamento das instâncias inclui um script automatizado que realiza as seguintes etapas:
1.  Instalação e configuração do motor Docker.
2.  Download da imagem Docker do repositório definido, utilizando a tag correspondente ao workspace do Terraform (ex: prod, staging).
3.  Verificação de conectividade com o banco de dados via utilitário de rede antes de iniciar a aplicação.
4.  Execução de migrações de banco de dados via Prisma.
5.  Inicialização do container da aplicação NestJS.

---

## Variáveis Necessárias

Para a execução deste projeto, as seguintes variáveis devem ser definidas (via arquivo .tfvars ou variáveis de ambiente):

* `vpc_cidr`: Bloco CIDR da VPC.
* `public_subnet_cidr`: Bloco CIDR para a primeira subnet.
* `public_subnet_b_cidr`: Bloco CIDR para a segunda subnet.
* `instance_type`: Tipo de instância EC2 (ex: t3.micro).
* `instance_count`: Capacidade máxima do Auto Scaling Group.
* `dockerhub_user`: Usuário do Docker Hub para pull da imagem.
* `dockerhub_repo`: Nome do repositório da imagem.
* `db_password`: Senha mestre para o banco de dados PostgreSQL.

---

## Como Utilizar

1.  **Inicializar o Terraform:**
    ```bash
    terraform init
    ```

2.  **Criar ou selecionar um Workspace:**
    ```bash
    terraform workspace new prod
    ```

3.  **Planejar a infraestrutura:**
    ```bash
    terraform plan
    ```

4.  **Aplicar as mudanças:**
    ```bash
    terraform apply
    ```

Ao final da execução, o Terraform exibirá o DNS público do Load Balancer no output `dns_do_ambiente`. Este é o endereço utilizado para acessar a API.
