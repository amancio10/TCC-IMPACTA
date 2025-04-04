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

    // Validação de login
    document.getElementById("loginForm").addEventListener("submit", function(event) {
        event.preventDefault();
        let username = document.getElementById("username").value;
        let password = document.getElementById("password").value;

        if (username === "" || password === "") {
            alert("Por favor, preencha todos os campos!");
        } else {
            alert("Login realizado com sucesso!");
        }
    });
};
