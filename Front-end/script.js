// script.js

// URL da API (atualize conforme o ngrok muda)
// const API_URL = 'https://cors-anywhere.herokuapp.com/https://218c-152-249-74-16.ngrok-free.app/api/perguntar';
const API_URL = 'http://localhost:8080/api/perguntar';
// Referências aos elementos do DOM
const chatForm = document.getElementById('chatForm');
const userInput = document.getElementById('userInput');
const chatBox = document.getElementById('chatBox');

/**
 * Adiciona uma nova mensagem à caixa de conversa.
 * As mensagens são inseridas no topo (primeiro filho) para que as interações fiquem "gravadas" na parte superior.
 * param {string} message - O conteúdo da mensagem.
 * param {string} sender - 'user' para mensagem do usuário ou 'gemini' para a resposta.
 */
function addMessage(message, sender) {
  const messageDiv = document.createElement('div');
  messageDiv.classList.add('message', sender);
  messageDiv.textContent = message;
  // Insere a mensagem no topo da chatBox
  chatBox.insertBefore(messageDiv, chatBox.firstChild);
}

// Trata o envio do formulário
chatForm.addEventListener('submit', function (event) {
  event.preventDefault();

  const question = userInput.value.trim();
  if (!question) return; // Não envia se estiver vazio

  // Exibe a pergunta do usuário na interface
  addMessage(question, 'user');

  // Limpa o campo de entrada
  userInput.value = '';

  // Prepara o corpo da requisição
  const data = { pergunta: question };

  // Faz a requisição POST para a API
  fetch(API_URL, {
    method: 'POST',
    headers: {
      'Origin': 'http://127.0.0.1:8080',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },
    body: JSON.stringify(data),
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error('Erro na resposta da rede');
      }
      return response.json();
    })
    .then((result) => {
      // Considera que a resposta JSON possua uma propriedade "resposta"
      const answer = result || 'Resposta não encontrada';
      addMessage(answer, 'gemini');
    })
    .catch((error) => {
      console.error('Erro na operação fetch:', error);
      addMessage('Erro ao obter resposta do GEMINI', 'gemini');
    });
});
