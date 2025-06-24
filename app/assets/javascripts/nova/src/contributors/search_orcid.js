document.addEventListener("DOMContentLoaded", function () {
  document.getElementById("search_orcid_btn").addEventListener("click", function (e) {
    const orcidInput = document.getElementById("contributor_identifiers_attributes_0_value");
    const orcidId = orcidInput ? orcidInput.value : '';

    const notificationArea = document.getElementById("notification-area");

    function showNotification(message) {
      if (!notificationArea) return;

      notificationArea.className = "notification-area alert alert-warning d-block";
      notificationArea.setAttribute("role", "alert");

      // Remove all <span> children
      const spans = notificationArea.querySelectorAll("span");
      spans.forEach(span => span.remove());

      // Append new message
      const screenReaderSpan = document.createElement("span");
      screenReaderSpan.className = "aria-only";
      screenReaderSpan.textContent = "Notice: ";

      const messageSpan = document.createElement("span");
      messageSpan.textContent = message;

      notificationArea.appendChild(screenReaderSpan);
      notificationArea.appendChild(messageSpan);
    }

    if (!orcidId) {
      showNotification("Please enter an ORCID ID.");
      return;
    }

    const orcidIdEncoded = encodeURIComponent(orcidId);
    fetch(`/orcid_records/?orcid_id=${orcidIdEncoded}`, {
      method: "GET",
      headers: {
        "Accept": "application/json"
      }
    })
    .then(response => response.json().then(data => ({ status: response.status, body: data })))
    .then(({ status, body }) => {
      const statusCode = String(body["status_code"]);

      if (statusCode.startsWith('2')) {
        // Success
        const nameField = document.getElementById("contributor_name");
        const emailField = document.getElementById("contributor_email");
        const orgIdField = document.getElementById("contributor_org_id");
        const orgNameField = document.getElementById("contributor_org_name");

        if (nameField) nameField.value = body["name"] || '';
        if (emailField) emailField.value = body["email"] || '';
        if (orgIdField) orgIdField.value = JSON.stringify(body["organization"]);
        if (orgNameField) orgNameField.value = body["organization"]?.["name"] || '';

      } else if (statusCode === '422') {
        showNotification("The ORCID iD is invalid.");
      } else if (statusCode.startsWith('4')) {
        showNotification("There was a problem with the request made to the ORCID system, and so the record could not be retrieved.");
      } else if (statusCode.startsWith('5')) {
        showNotification("There was a problem in ORCID system, and so the record could not be retrieved.");
      } else {
        showNotification("There was a problem in the system, and so the project details could not be retrieved.");
      }
    })
    .catch(error => {
      console.error("Error fetching ORCID record:", error);
      showNotification("An unexpected error occurred while retrieving the ORCID record.");
    });
  });
});