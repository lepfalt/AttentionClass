# Attention Class

<h1 align="center"><img src="https://user-images.githubusercontent.com/36510291/97642455-f1edc080-1a23-11eb-936d-e22c284fa996.png" width="600"></h1>
<h3 align="center"> 📌 Sistema de Gerenciamento de Tarefas da Turma.</h3>
</br>
<p>Este é um trabalho acadêmico prestado ao programa de graduação em Ciência da Computação do Centro Universitário Carioca. O desafio realizado é um projeto de Gerenciamento de Tarefas da Turma cujo nome escolhido foi "Attention Class".</p>

<p><i>Já pensou o quanto a falta de organização pode afetar seus afazeres?</i></p>
<p>No meio acadêmico, isso é um desafio. Alguns alunos utilizam de agendas, aplicativos, e várias outras ferramentas a fim de não perder nenhuma tarefa. No entanto, seu organizador não está sempre atualizado, pois o esquecimento pode se tornar habitual em meio a correria do dia a dia. O que resulta, muitas vezes, em tarefas sendo feitas na última hora ou nem mesmo sendo entregues. Os professores também são afetados por isso, em meio a correção de provas, trabalhos, notas, preparo de conteúdos para várias e várias turmas. Isso ocorre em muitas áreas e no dia a dia de muita gente independente da área de atuação.</p>

<p><i>Então, por que não otimizar nossas tarefas da melhor forma?</i></p> 
<p>No cenário acadêmico, por exemplo, imagine poder juntar a dinâmica do lançamento de tarefas dos professores - e todo o gerencimento necessário para controlar tantas turmas diferentes - com um organizador de tarefas de acordo com o status de desenvolvimento pelo aluno. Esse é o objetivo desse projeto, ajudar na execução e interação de tarefas para ambos os papéis.</p>

<p>O Attention Class é um organizador de tarefas em que o administrador da turma/grupo passa tarefas e se organiza com o andamento das mesmas, assim como o usuário comum(executador das tarefas) as recebe de forma organizada no seu board e a manuseia de acordo com o andamento dela. 
Ao fim, o usuário comum envia a tarefa e o adminsitrador tem visualização dos resultados da turma podendo avaliar cada um deles.</p>

<p>A grande iniciativa é que ambos fazem seus deveres de maneira organizada e de fácil acesso para cada um deles. </p>

<strong>  Atenção! <i>O foco é no aumento da produtividade! </i></strong>

</br>

<h2>⚙ Funcionamento</h2>
<p>⤷ O administrador do grupo posta as tarefas com todas as instruções necessárias para a resolução e os requisitos da entrega;</p>
<p>⤷ Os integrantes desse grupo recebem a tarefa, que fica armazenada na coluna do devido status.</p>  
</br>

<h2>✅ Features</h2>
<h6>Perfil Administrador</h6>

- [x] Postagem de Tarefas
- [x] Registro de tarefas entregues por cada integrante do grupo
- [x] Organização por turma

<h6>Perfil Comum</h6>

- [x] Kanban com status de cada tarefa
- [X] Tarefas de todos os seus grupos no mesmo board
</br>

<h2>🛠️ Tecnologias</h2>
<h5>✦ Linguagem Ruby</h5>
<h5> Framework Rails</h5>
<h5> PostgreSQL</h5>
<h5> Twitter Bootstrap Rails</h5>

</br>
<h2>🚀 Instalação</h2>
<p>É necessária a instalação de alguns programas e bibliotecas para configuração local deste projeto. Essa configuração será detalhada nos itens abaixo.</p>

### WSL
<p>A linguagem Ruby escolhida não é compatível com alguns programas de SOs. Portanto, para os usuários de Windows é necessário a intalação da WSL (Windows Subsystem for Linux), que é um subprograma windows para uso de serviços linux, permitindo o desenvolvimento desse projeto dentro deste sistema operacional.</p>

A instalação deve ser feita conforme o link <a href="https://docs.microsoft.com/pt-br/windows/wsl/install-win10 ">WSL</a>. Nesta estapa o computador deve ser reiniciado. É aconselhado a utilização do WSL2.

### PostgreSQL
<p>Com o SO devidamente configurado ou compatível com a ferramenta, o próximo passo é a instalação do banco de dados, que nesse caso será o Postgres.</p>

A instalação pode ser feita através do link <a href="https://www.enterprisedb.com/downloads/postgresql">Postgres</a> de acordo com o SO usado.

Em alguns casos, pode ser necessário a alteração da senha conforme o link <a href="http://help.market.com.br/desenvolvimento/trocar_senha_usuario_postgresq.htm">Update Password Postgres</a>. Ou a alteração da senha pode também ser feita direto no arquivo `./config/database.yml` do projeto.

### Ruby On Rails
<p>A instalação do Ruby e do Rails são feitas separadamente. É aconselhavél para o Ruby o uso de um versionador, neste projeto foi usado o RBenv.</p>

<p>Link para instalação do Ruby <a href="https://www.theodinproject.com/courses/ruby-programming/lessons/installing-ruby-ruby-programming">Tutorial Ruby</a></p>
<p>Link para instalação do Rails <a href="https://www.theodinproject.com/courses/ruby-on-rails/lessons/your-first-rails-application-ruby-on-rails">Tutorial Rails</a></p>
<p>Tem também um tutorial completo que auxilia na instalação de ambos pelo WSL: <a href="https://gorails.com/setup/windows/10">Tutorial Completo</a></p>

### Node e Yarn
<p>É necessário a instalação do node e yarn para uso de algumas bibliotecas.</p>

Link para instalação do <a href="https://nodejs.org/en/">Node</a>.

Para instalar o yarn e suas dependências é necessário rodar o seguinte comando no terminal:

    yarn install
    
### GIT
Para clonar e versionar o projeto, deve ser instalado e configurado o git. Através do link <a href="https://git-scm.com/downloads">GIT</a>.

### Comandos Iniciais
<p>Com as intalações realizadas e o projeto devidamente clonado, alguns comando devem ser rodados para configurar o projeto local.</p>

Priemiro é necessário rodar o `bundle` para que todas as gems declaradas no `Gemfile` sejam usadas localmente:

    bundle install
    
Após isso, em alguns casos, é necessário rodar o `yarn` também dentro do projeto:

    yarn install
    
Então devem ser executados comandos de criação e migração do banco de dados local através do rails:

    rails db:create     // cria os bancos de teste e desenvolvimento declarados no database.yml
    rails db:migrate    // executa todas as migrações para gerar as tabelas e suas configurações
    
Por fim, basta startar o projeto e acessá-lo localmente em `localhost:3000`:

    rails s             // roda o projeto
   
</br>
<h2>✨ Considerações Finais</h2>

### Envio de E-mail
Para essa funcionalidade é necessário declarar as credenciais do email a ser usado. Isso pode ser feito criando um arquivo com o nome de `./config/local_env.rb` com os seguintes campos:

    USERNAME_EMAIL: 'seu email aqui'
    PASSWORD_EMAIL: 'sua senha aqui'
    SEED: 'semente pro hash do reset de senha'    // pode ser qualquer palavra para elevar o nível de criptografia
    
### Rotas
É possível visualizar todas as rotas do sistema atráves da url: `localhost:3000/rails/info/routes` durante a execução local.
