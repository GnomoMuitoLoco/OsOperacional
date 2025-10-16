# Os Operacional

Um aplicativo Flutter simples e funcional para gerenciamento pessoal de ordens de serviço (OS). Este projeto foi desenvolvido para uso pessoal, mas o código está disponível como base livre para quem quiser estudar, adaptar ou estender.

Índice
- Visão geral
- Status do projeto
- Recursos principais
- Estrutura do projeto
- Tecnologias e dependências
- Banco de dados
- Permissões necessárias
- Instalação e execução (Windows / Android / iOS)
- Como usar
- Contribuições
- Licença
- Contato

Visão geral

"Os Operacional" é um app leve para registrar, listar e gerenciar ordens de serviço localmente no dispositivo. O objetivo é manter uma base pessoal de OSs com campos essenciais, permitir anexar imagens, gerar PDFs e assinar digitalmente quando necessário.

Status do projeto

- Estado: Funcional (aplicativo básico pronto para uso pessoal)
- Plataforma alvo: Android, iOS, Windows (Flutter)
- Uso pretendido: pessoal / base de estudo

Recursos principais

- Criar, editar e remover ordens de serviço
- Armazenamento local com SQLite (sqflite)
- Anexar imagens usando a câmera ou galeria (image_picker)
- Gerar PDF da OS e imprimir/salvar (pdf, printing)
- Captura de assinatura (signature)
- Interface simples baseada em Material

Estrutura do projeto (principais arquivos)

- `lib/main.dart` — ponto de entrada do app
- `lib/db/database_helper.dart` — helper para SQLite (CRUD)
- `lib/models/order.dart` — modelo de dados para ordens de serviço
- `lib/pages/home_page.dart` — tela inicial
- `lib/pages/os_list_page.dart` — listagem de OSs
- `lib/pages/os_form_page.dart` — formulário para criar/editar OS
- `lib/pages/os_detail_page.dart` — detalhe da OS (visualizar, gerar PDF, assinar)

(Consulte a pasta `lib/` para o código completo.)

Tecnologias e dependências

Este projeto usa Flutter e as seguintes dependências (conforme `pubspec.yaml`):

- Flutter SDK (ambiente do projeto: Dart SDK ^3.7.2)
- sqflite — banco de dados SQLite
- path — manipulação de paths
- path_provider — localização de diretórios no dispositivo
- image_picker — captura/seleção de imagens
- pdf — geração de documentos PDF
- printing — impressão / salvar PDFs
- signature — captura de assinatura digital
- cupertino_icons — ícones iOS

Banco de dados

O app utiliza SQLite através do pacote `sqflite`. Os dados são persistidos localmente no dispositivo. A estrutura e as migrations são tratadas em `lib/db/database_helper.dart`.

Permissões

O app pode solicitar permissões em tempo de execução para:
- Acesso à câmera e galeria (para anexar imagens)
- Acesso a armazenamento em algumas plataformas (para salvar PDFs)

Instalação e execução

Pré-requisitos
- Flutter instalado e configurado (versão compatível com o SDK do projeto)
- Android SDK (para rodar no emulador/dispositivo Android)
- Xcode (somente macOS, para iOS)
- Visual Studio (somente Windows, para build Windows) — se quiser compilar para desktop

1) Obter dependências

```cmd
cd "c:\Users\vinic\Desktop\Novo\OsOperacional"
flutter pub get
```

2) Executar em um dispositivo ou emulador Android

```cmd
flutter run -d android
```

3) Executar no Windows (se desejar)

```cmd
flutter run -d windows
```

4) Build de release (exemplo Android APK)

```cmd
flutter build apk --release
```

5) Executar testes (se existirem)

```cmd
flutter test
```

Observações
- Se ocorrerem erros relacionados a permissões ou API levels no Android, verifique `android/app/src/main/AndroidManifest.xml` e as configurações de `build.gradle`.
- Para iOS, rode `flutter build ios` em um macOS com Xcode instalado e siga as instruções de provisionamento da Apple.

Como usar

- Abra o app, toque em "+" para criar uma nova ordem de serviço.
- Preencha os campos necessários (título, descrição, cliente, data, etc.).
- Anexe fotos se precisar (ícone de imagem) — permita acesso à câmera/galeria.
- Salve a OS; ela aparecerá na lista principal.
- Ao ver detalhes, você pode gerar um PDF ou capturar uma assinatura.

Contribuições

Contribuições são bem-vindas. Como este repositório foi criado para uso pessoal, não há um fluxo rígido de contribuição, mas sugestões são aceitas:
- Abra uma issue descrevendo o problema ou a feature desejada
- Abra um pull request com mudanças claras e testáveis

Licença

O projeto foi criado para uso pessoal, mas sinta-se livre para usar o código como base em seus próprios projetos.

Contato

Se quiser falar sobre este projeto, sugestões ou dúvidas, adicione uma issue no repositório ou entre em contato diretamente (discord: GnomoMuitoLoco).

Obrigado por usar/estudar "Os Operacional"!
