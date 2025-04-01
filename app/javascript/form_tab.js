document.addEventListener("DOMContentLoaded", () => {
  rebindTabEvents();
  updateTabContent("capture");
  window.openCamera = openCamera;
  window.capturePhoto = capturePhoto;
  window.openCheckForm = openCheckForm;
});

function rebindTabEvents() {
  document.querySelectorAll(".nav-link").forEach(button => {
    button.addEventListener("click", event => setActiveTab(event.target.getAttribute("data-tab")));
  });
}

// Function to handle form success and re-enable tabs
function openCheckForm() {
  const successMessage = document.querySelector(".alert-success");
  if (successMessage) {
    successMessage.remove();
  }
  document.getElementById("tabContent").classList.remove("d-none");
  updateTabContent("capture");

  rebindTabEvents();
}

function setActiveTab(tab) {
  document.querySelectorAll(".nav-link").forEach(btn => btn.classList.remove("active"));
  document.querySelector(`.nav-link[data-tab="${tab}"]`).classList.add("active");
  updateTabContent(tab);
}

function updateTabContent(tab) {
  const contentDiv = document.getElementById("tabContent");
  contentDiv.innerHTML = "<p>Loading...</p>";
  
  const url = tab === "capture" ? "/captures/new" : `/${tab}.json`;
  fetch(url)
    .then(response => (tab === "capture" ? response.text() : response.json()))
    .then(data => contentDiv.innerHTML = tab === "capture" ? data : renderTable(data))
    .catch(() => contentDiv.innerHTML = "<p class='text-danger'>Failed to load data.</p>");
}

function renderTable(data) {
  if (!data.length) return "<p class='text-muted'>No records found.</p>";
  
  const headers = Object.keys(data[0]).map(key => `<th>${key.replace(/_/g, ' ')}</th>`).join('');
  const rows = data.map(row => `<tr>${Object.values(row).map(value => `<td>${value || "N/A"}</td>`).join('')}</tr>`).join('');
  
  return `<table class='table table-bordered table-striped'><thead><tr>${headers}</tr></thead><tbody>${rows}</tbody></table>`;
}

function openCamera() {
  navigator.mediaDevices.getUserMedia({ video: true })
    .then(stream => {
      const videoElement = document.getElementById("video");
      if (!videoElement) return;
      videoElement.srcObject = stream;
      videoElement.play();
      document.getElementById("cameraContainer").classList.remove("d-none");
      window.videoStream = stream;
    })
    .catch(() => alert("Camera access denied or unavailable. Please check permissions."));
}

function capturePhoto() {
  const video = document.getElementById("video");
  if (!video?.videoWidth) return;

  const canvas = document.createElement("canvas");
  canvas.width = video.videoWidth;
  canvas.height = video.videoHeight;
  canvas.getContext("2d").drawImage(video, 0, 0, canvas.width, canvas.height);
  
  document.getElementById("photo").src = canvas.toDataURL("image/png");
  document.getElementById("imageData").value = canvas.toDataURL("image/png");
  document.getElementById("photo").classList.remove("d-none");
  document.getElementById("cameraContainer").classList.add("d-none");
  
  window.videoStream?.getTracks().forEach(track => track.stop());
  window.videoStream = null;
}
