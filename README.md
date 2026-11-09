# Achados e Perdidos — UESPI

Aplicativo móvel em Flutter para divulgação e consulta de objetos perdidos e encontrados no campus universitário da UESPI, permitindo que estudantes, docentes e funcionários publiquem e busquem itens de forma rápida e centralizada.

## Equipe

- Gabriel Oliveira Pinto
- Adonias Pereira dos Santos Terceiro

## Funcionalidades

- **Listagem de objetos (RF01)**
  - Dados obtidos diretamente da nuvem em tempo real;
  - Identificação visual imediata da situação (Perdido em vermelho / Encontrado em verde);
  - Ordenação automática pelos registros mais recentes primeiro (`created_at DESC`);
  - Atualização manual por botão na barra superior (`AppBar`) e suporte a gesto *pull-to-refresh*.
- **Cadastro de objetos (RF02)**
  - Formulário com campos para nome (até 60 caracteres), descrição (até 200 caracteres), local e situação (Perdido / Encontrado);
  - Validação estrita de todos os campos com feedback interativo (`AutovalidateMode.onUserInteraction`);
  - Data e hora registradas automaticamente pelo servidor (`now()`), eliminando inconsistências.
- **Assincronismo e Resiliência (RF03)**
  - Indicadores visuais de carregamento (`CircularProgressIndicator`);
  - Bloqueio de submissão dupla durante o envio para evitar duplicação de dados;
  - Tratamento de falhas de conexão com mensagens amigáveis e botão para nova tentativa ("Tentar novamente").
- **Gerenciamento de Estado (RF04)**
  - Arquitetura reativa baseada em `ChangeNotifier` + `Provider` centralizada no `ItemsController`.
- **Persistência em Nuvem (RF05)**
  - Banco de dados PostgreSQL hospedado no Supabase (plano gratuito), sem necessidade de autenticação.

## Serviços em Nuvem

- **Supabase** (plano gratuito, sem autenticação) — tabela `public.items` com políticas de Row Level Security (RLS) que permitem estritamente operações de `SELECT` e `INSERT` para o papel público (`anon`).
- A URL do projeto e a `publishable key` (chave pública por design, protegida por RLS — item 8.2 do edital) estão configuradas em [`lib/config/supabase_config.dart`](lib/config/supabase_config.dart).
- O script SQL de criação da tabela, restrições e políticas de RLS encontra-se em [`docs/supabase/schema.sql`](docs/supabase/schema.sql).

## Como Executar

### Pré-requisitos

- [SDK Flutter](https://docs.flutter.dev/get-started/install) instalado e configurado (versão 3.x ou superior com suporte a Web).
- Navegador Google Chrome.

### Passos para Execução

1. Clone o repositório:
   ```bash
   git clone https://github.com/gaboliveira-alt/pmob_aval2.git
   cd pmob_aval2
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Execute a aplicação no Chrome:
   ```bash
   flutter run -d chrome
   ```

> As credenciais públicas de acesso ao Supabase já estão previamente configuradas em `lib/config/supabase_config.dart`, permitindo que o projeto execute e compile imediatamente após o clone.

## Estrutura do Projeto

O código-fonte segue arquitetura em camadas bem definida sob o diretório `lib/`:

- **`config/`**: Configurações de ambiente e credenciais públicas da nuvem (`supabase_config.dart`);
- **`data/`**: Implementações concretas de acesso a dados (`supabase_item_repository.dart`);
- **`domain/`**: Modelos de domínio puros (`found_item.dart`, `item_situation.dart`) e contratos abstratos de repositório (`item_repository.dart`);
- **`presentation/`**:
  - **`controllers/`**: Gerenciador de estado reativo da aplicação (`items_controller.dart`);
  - **`screens/`**: Telas principais da aplicação (`items_list_screen.dart`, `register_item_screen.dart`);
  - **`widgets/`**: Componentes visuais reutilizáveis (`item_card.dart`, `situation_badge.dart`).

---

UESPI — Programação para Dispositivos Móveis (2ª Avaliação)
