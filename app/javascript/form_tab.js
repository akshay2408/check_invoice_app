document.addEventListener("DOMContentLoaded", function () {
  rebindTabEvents();
  updateTabContent("capture");
  window.openCamera = openCamera;
  window.capturePhoto = capturePhoto;
  window.openCheckForm = openCheckForm;
});

// Function to rebind tab events
function rebindTabEvents() {
  document.querySelectorAll('.nav-link').forEach(button => {
    button.removeEventListener('click', handleTabClick);
    button.addEventListener('click', handleTabClick);
  });
}

function handleTabClick(event) {
  const tab = event.target.getAttribute('data-tab');
  setActiveTab(tab);
}

function setActiveTab(tab) {
  document.querySelectorAll('.nav-link').forEach(btn => btn.classList.remove('active'));
  document.querySelector(`.nav-link[data-tab="${tab}"]`).classList.add('active');

  document.getElementById("tabContent").classList.remove("d-none");
  document.getElementById("tabContent").innerHTML = "<p>Loading...</p>";

  updateTabContent(tab);
}

function updateTabContent(tab) {
  const contentDiv = document.getElementById('tabContent');
  contentDiv.innerHTML = "<p>Loading...</p>";

  if (tab === "capture") {
    fetch("/captures/new")
      .then(response => response.text())
      .then(html => {
        contentDiv.innerHTML = html;
        rebindTabEvents(); // Ensure tab buttons work after updating content
      })
      .catch(error => {
        console.error("Error loading capture:", error);
        contentDiv.innerHTML = "<p class='text-danger'>Failed to load content.</p>";
      });
  } else {
    fetch(`/${tab}.json`)
      .then(response => response.json())
      .then(data => {
        contentDiv.innerHTML = renderTable(data);
        rebindTabEvents(); // Ensure tab buttons work after updating content
      })
      .catch(error => {
        console.error("Error loading tab data:", error);
        contentDiv.innerHTML = "<p class='text-danger'>Failed to load data.</p>";
      });
  }
}

// Function to render table from JSON data
function renderTable(data) {
  if (!data.length) return "<p class='text-muted'>No records found.</p>";
  let table = `<table class='table table-bordered table-striped'><thead><tr>`;
  Object.keys(data[0]).forEach(key => table += `<th>${key.replace(/_/g, ' ')}</th>`);
  table += `</tr></thead><tbody>`;
  data.forEach(row => {
    table += `<tr>`;
    Object.values(row).forEach(value => table += `<td>${value || "N/A"}</td>`);
    table += `</tr>`;
  });
  table += `</tbody></table>`;
  return table;
}

// Function to handle form success and re-enable tabs
function openCheckForm() {
  const successMessage = document.querySelector(".alert-success");
  if (successMessage) {
    successMessage.remove();
  }
  document.getElementById("tabContent").classList.remove("d-none");
  updateTabContent("capture");

  rebindTabEvents(); // Re-enable tabs after success
}

// Camera functionality
function openCamera() {
  const videoElement = document.getElementById('video');

  if (!videoElement) {
    console.error("Video element not found!");
    return;
  }

  navigator.mediaDevices.getUserMedia({ video: true })
    .then(stream => {
      window.videoStream = stream;
      videoElement.srcObject = stream;
      videoElement.play();
      
      document.getElementById('cameraContainer').classList.remove('d-none');
      console.log("Camera stream started!");
    })
    .catch(err => {
      console.error("Camera Error:", err);
      alert("Camera access denied or unavailable. Please check permissions.");
    });
}

// Function to capture photo from camera stream
function capturePhoto() {
  const video = document.getElementById('video');
  if (!video || !video.videoWidth) {
    console.error("Video stream not available.");
    return;
  }

  const canvas = document.createElement('canvas');
  canvas.width = video.videoWidth;
  canvas.height = video.videoHeight;
  const context = canvas.getContext('2d');
  context.drawImage(video, 0, 0, canvas.width, canvas.height);

  const photo = document.getElementById('photo');
  const imageDataURL = canvas.toDataURL("image/png");

  photo.src = imageDataURL;
  photo.classList.remove('d-none');
  document.getElementById('imageData').value = imageDataURL;

  // Stop video stream
  if (window.videoStream) {
    window.videoStream.getTracks().forEach(track => track.stop());
    window.videoStream = null;
  }

  document.getElementById('cameraContainer').classList.add('d-none');
}
