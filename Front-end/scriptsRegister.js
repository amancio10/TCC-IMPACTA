window.onload = function () {
    const bg = document.querySelector(".bg-img");

    window.addEventListener("mousemove", (e) => {
        const mouseX = e.clientX;
        const mouseY = e.clientY;
        const decX = mouseX / window.innerWidth;
        const decY = mouseY / window.innerHeight;
        const maxX = bg.offsetWidth - window.innerWidth;
        const maxY = bg.offsetHeight - window.innerHeight;

        const panX = decX * maxX;
        const panY = decY * maxY;

        bg.style.transform = `translate(${-panX}px, ${-panY}px)`;
    });

    // Envio do formulário de cadastro
    const cadastroForm = document.getElementById("cadastroForm");

    if (cadastroForm) {
        cadastroForm.addEventListener("submit", async function (event) {
            event.preventDefault();

            const nome = document.getElementById("nome").value.trim();
            const email = document.getElementById("email").value.trim();
            const senha = document.getElementById("password").value;
            const confirmSenha = document.getElementById("confirmPassword").value;

            if (!nome || !email || !senha || !confirmSenha) {
                alert("Por favor, preencha todos os campos.");
                return;
            }

            if (senha !== confirmSenha) {
                alert("As senhas não coincidem.");
                return;
            }

            try {
                const response = await fetch("http://localhost:8080/api/register", {
                    method: "POST",
                    headers: {
                        "Origin": "http://127.0.0.1:4040",
                        "X-Requested-With": "XMLHttpRequest",
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        id: Math.floor(Math.random() * 1000000), // Gera um ID aleatório
                        nome,
                        email,
                        senha
                    })
                });

                const resText = await response.text();

                if (response.ok) {
                    alert("Cadastro realizado com sucesso!");
                    // Redireciona para login
                    window.location.href = "login.html";
                } else {
                    if (resText.includes("email") || resText.includes("já cadastrado")) {
                        alert("Este e-mail já está em uso.");
                    } else {
                        alert("Erro no cadastro: " + resText);
                    }
                }
            } catch (error) {
                console.error("Erro ao enviar dados:", error);
                alert("Erro ao conectar com o servidor.");
            }
        });
    }
};