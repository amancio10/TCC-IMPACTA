window.onload = function() {

    // Background interativo
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

    document.getElementById("login-form").addEventListener("submit", async function (event) {
        event.preventDefault();

        const email = document.getElementById("username").value.trim();
        const senha = document.getElementById("password").value;

        if (username === "" || password === "") {
            alert("Por favor, preencha todos os campos!");
            return;
        }

        try {
            const response = await fetch("http://localhost:8080/api/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    // Se você precisar de headers como APP-KEY ou APP-TOKEN, adicione aqui:
                    // "APP-KEY": "sua-chave",
                    // "APP-TOKEN": "seu-token"
                },
                body: JSON.stringify({ email, senha })
            });

            const data = await response.text();
            console.log(data)
            if (data.includes("True")) {
                window.location.href = "/Front-end/index.html";
                // Redirecionar ou salvar token, etc.
            } else {
                alert(data.message || "Erro no login.");
            }
        } catch (error) {
            console.log(error)
            console.error("Erro ao enviar dados:", error);
            alert("Erro de conexão com o servidor.");
        }
    });
};
