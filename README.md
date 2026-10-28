# Achados e Perdidos — UESPI

Aplicativo móvel em Flutter para divulgação e consulta de objetos perdidos e encontrados no campus universitário da UESPI, permitindo que estudantes, docentes e funcionários publiquem e busquem itens de forma rápida e centralizada.

## Equipe

- Gabriel Oliveira Pinto
- Adonias Pereira dos Santos Terceiro

## Funcionalidades

- **Listagem de objetos**
  - Dados obtidos da nuvem;
  - Identificação visual da situação (perdido/encontrado);
  - Ordenação pelos itens mais recentes primeiro;
  - Atualização da listagem.
- **Cadastro de objetos**
  - Nome (até 60 caracteres) e descrição (até 200 caracteres);
  - Local e situação (perdido/encontrado);
  - Validação dos campos preenchidos;
  - Data e hora preenchidas automaticamente.
- **Assincronismo**
  - Indicadores de carregamento;
  - Prevenção de envios repetidos;
  - Tratamento de erros com opção de nova tentativa.
- **Gerenciamento de estado**
  - Organização e reatividade dos dados exibidos na interface.
- **Armazenamento em nuvem**
  - Serviço gratuito, sem necessidade de autenticação.

## Serviços em nuvem

<!-- TODO: definir o serviço de armazenamento (ex.: Firebase Firestore, Supabase) e documentar chaves/URLs de configuração -->

## Como executar

### Pré-requisitos

- [SDK Flutter](https://docs.flutter.dev/get-started/install) instalado e configurado.

### Passos

```bash
flutter pub get
flutter run
```

<!-- TODO: documentar a configuração das credenciais do serviço em nuvem (arquivos de configuração, chaves/URLs) antes de executar -->

## Estrutura do projeto

O projeto segue uma arquitetura em camadas, organizada sob `lib/`:

- **domain**: regras de negócio e modelos dos dados;
- **presentation**: widgets e telas que exibem a informação ao usuário.

---

UESPI — Programação para Dispositivos Móveis
