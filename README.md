# Desafio: Congresso Universitário

## Descrição do Projeto

Este desafio consiste em desenvolver um sistema de gerenciamento para um congresso universitário, que contará com palestras e workshops. Os participantes, que podem ser alunos da universidade ou visitantes externos, poderão se inscrever livremente nas palestras. Para os workshops, haverá um número limitado de vagas, o que requer um controle mais rigoroso nas inscrições.

O objetivo deste projeto é criar a estrutura de dados necessária e desenvolver stored procedures para gerenciar as inscrições, palestras e workshops, além de gerar relatórios personalizados para cada participante.

## Estrutura do Sistema

### 1. Participante
- **Descrição**: Todo participante pode ser um aluno da universidade ou um visitante.
- **Atributos**:
  - ID (chave primária)
  - Nome
  - Tipo (Aluno ou Visitante)
  - E-mail
  - Curso (aplicável apenas a Alunos)

### 2. Palestra
- **Descrição**: Palestras são abertas e sem limite de vagas.
- **Atributos**:
  - ID (chave primária)
  - Título
  - Descrição
  - Palestrante
  - Data e Hora
  - Duração (em horas)

### 3. Workshop
- **Descrição**: Workshops possuem limite de vagas, e os participantes precisam se inscrever para garantir a participação.
- **Atributos**:
  - ID (chave primária)
  - Título
  - Descrição
  - Instrutor
  - Data e Hora
  - Duração (em horas)
  - Vagas Disponíveis

### 4. Inscrição Palestra
- **Descrição**: Os participantes podem se inscrever livremente em qualquer palestra.
- **Atributos**:
  - ParticipanteID (chave estrangeira de Participante)
  - PalestraID (chave estrangeira de Palestra)

### 5. Inscrição Workshop
- **Descrição**: Para workshops, além de cadastrar a inscrição, é necessário garantir que as vagas disponíveis sejam respeitadas.
- **Atributos**:
  - ParticipanteID (chave estrangeira de Participante)
  - WorkshopID (chave estrangeira de Workshop)

## Tarefas e Etapas

1. **Inserir Participantes**: 
   - Desenvolver uma stored procedure para inserir novos participantes, considerando o tipo (aluno ou visitante) e as informações pertinentes.

2. **Cadastrar Palestras**: 
   - Criar uma stored procedure que permita adicionar novas palestras ao banco de dados, com todos os atributos necessários.

3. **Cadastrar Workshops**: 
   - Criar uma stored procedure para cadastrar workshops, definindo o limite de vagas disponíveis.

4. **Inscrever Participantes em Palestras**: 
   - Desenvolver uma stored procedure para gerenciar as inscrições dos participantes nas palestras.

5. **Inscrever Participantes em Workshops**: 
   - Criar uma stored procedure que registre a inscrição e verifique se há vagas disponíveis.

6. **Remover Participantes**: 
   - Implementar uma stored procedure para remover participantes, incluindo suas inscrições em palestras e workshops.

7. **Gerar Relatório de Participação**: 
   - Criar stored procedures que gerem relatórios personalizados para participantes e para cada palestra/workshop, incluindo a quantidade de participantes e a taxa de interesse nos workshops.

## Relacionamentos
- Participantes podem se inscrever em várias Palestras e Workshops.
- Workshops têm um limite de vagas, enquanto Palestras não possuem esse limite.
- Cada Participante pode ser um Aluno ou um Visitante, ambos podendo se inscrever em qualquer evento do congresso.

## Desafio Final
Seu sistema deve garantir a integridade dos dados, respeitando as vagas limitadas para workshops. Além disso, a geração de relatórios de participação é essencial para entender a carga horária total cumprida pelos participantes. O uso correto de subqueries, JOINs e stored procedures será fundamental para o sucesso deste desafio.
