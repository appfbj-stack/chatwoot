# OPERACAO SAAS

## Nome oficial

- `NEXUS IA Atendimento`
  - este repositório é o projeto do Chatwoot
  - atendimento
  - inbox
  - agentes
  - WhatsApp
  - automações de conversa

## Repositórios

- Atendimento:
  - `https://github.com/appfbj-stack/chatwoot`

- CRM:
  - `https://github.com/appfbj-stack/gestao-de-clientes-de-som`

## Regra principal

- `chatwoot` = `NEXUS IA Atendimento`
- `gestao-de-clientes-de-som` = `NEXUS IA CRM`
- não misturar stack de um no outro

## Domínios

- Atendimento:
  - `chat.seudominio.com`

- CRM:
  - `crm.seudominio.com`

## Função deste repositório

Este repositório deve manter:

- stack docker do Chatwoot
- branding do Chatwoot
- overrides do Super Admin
- `.env.example` do atendimento
- deploy do atendimento

## Integração com o CRM

O `NEXUS IA Atendimento` conversa com o `NEXUS IA CRM` por:

- API
- webhook

Webhook esperado no CRM:

- `https://crm.seudominio.com/api/chatwoot/webhook`

## Nome que deve lembrar

- nome novo do Chatwoot:
  - `NEXUS IA Atendimento`

- nome do CRM:
  - `NEXUS IA CRM`
