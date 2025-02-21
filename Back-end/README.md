# Detalhes
### Como usar:
Na pasta API-Release você irá encontrar todos os arquivos necessários para utilização da API. <br>

### Configurando os .ini
O arquivo cGemini.ini contem:
```.ini
[Config]
URLBase=https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=
Key=AIzaSyBTB62ox4J_wSkLS6_68q6OMiRZGYyg0mQ
Devolver=JSON
```
__URLBase__ = URL de acesso a API do Gemini. <br>
__Key__ = chave de acesso ao Gemini. <br> 
__Devolver__ = Tipo de dado que a API logal vai devolver, se o parâmetro estiver como 'SQL' a API devolverá um comando SQL "limpo", se o parâmetro estiver como SJON a API irá tratar o comando SQL vindo do Gemini, fazer uma consulta na base de dados e devolver um JSON com os dados coletados.
<br>
<br>
O arquivo Conexao.ini contem os dados de acesso a sua base local:
```.ini
[Config]
Database=C:\Users\amanc\OneDrive\Documentos\TRS\IA\Win32\Debug\JCF.FDB
User_Name=SYSDBA
Password=masterkey
DriverID=FB
```
Este projeto está usando FireBird 2.5 <br>
User_Name e Password são o padrão do FireBird, mude apenas o __Database__ para o caminho correto em sua maquina

### Configurando os .config
O arquivo prompt.config contem a estrutura das duas tabelas que serão envidas junto com a pergunta do usuário ao Gemini.
<br>
<br>
O arquivo complemento.config possue o complemento da pergunda do usuário, para ajudar a IA a entender o ambiente e também é usado para impor regras à IA, exemplo:
```
Os dados acima são de uma estrurura de de tabelas mestre detalhes.
Considere essas informações para responder a pergunda abaixo, 
gerando um comando SQL, 
sem nenhum comentario, 
apenas o comando SQL, 
com o FireBird 2.5

DEVOLVA APENAS COMANDO DE SELEÇÃO (SELECT).
NÃO DEVOLVA COMANDO DE DELETE, INSERT OU UPDATE.
```

### Usando a API
Abra o arquivo _API.exe, irá abrir na porta 8080
![image](https://github.com/user-attachments/assets/82b45d6c-7b2d-4c53-9ac6-355aad74ff6d)

Teste o endpont:
```
Tipo: POST
Endpoint: http://localhost:8080/api/perguntar
```
Corpo da requisição:
``` json
{
  "pergunta": "Quantos clientes compraram?"
}

```
#### Retorno
O retorno da API será um JSON variado, podendo vir um número ou um array com varios campos e dados, isso dependerá da pergunda do usuário.

## Dica
Caso queira usar essa API na web para testes use o __Ngrok__: https://ngrok.com/
