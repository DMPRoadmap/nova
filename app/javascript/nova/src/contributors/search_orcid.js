$(() => {
  $('#search_orcid_btn').on('click', (e) => {
    const orcidId = $('#contributor_identifiers_attributes_0_value').val();

    // check if orcid-id has been entered by user
    if (
      orcidId == '' ||
      orcidId == null ||
      orcidId == undefined
    ) {
      // user did not enter orcid-id
      // inform user of outcome with flash message
      $('#notification-area').removeClass();
      $('#notification-area').addClass("notification-area alert alert-warning d-block");
      $('#notification-area').attr('role', 'alert');
      var spans = $('#notification-area span');
      for (var i = 0; i < spans.length; i++) {
        spans[i].remove(); 
      };
      $('#notification-area').append('<span class="aria-only">Notice: </span>');
      $('#notification-area').append('<span>Please enter an ORCID ID.</span>');
    } else {
      // user entered orcid-id so try to retrieve the orcid record
      // from orcid
      const orcidIdEncoded = encodeURIComponent(orcidId);
      $.ajax({
        type: 'GET',
        url: '/orcid_records/?orcid_id=' + orcidIdEncoded,
        headers: {
          'Accept': 'application/json'
        },
        complete: (jqXHR, textStatus) => { 
          response = jqXHR.responseJSON;

          if (response && response["status_code"][0] === '2') {
            // set name
            var contributor_name = $('#contributor_name');
            contributor_name.val(response["name"]);
            
            // set email
            $('#contributor_email').val(response["email"]);

            // set org
            $('#contributor_org_id').val(JSON.stringify(response["organization"]));
            $('#contributor_org_name').val(response["organization"]["name"]);

          } else if (response["status_code"] === '422') {
            // call was unsuccessful, orcid-id is invalid
            // inform user of outcome with flash message
            $('#notification-area').removeClass();
            $('#notification-area').addClass("notification-area alert alert-warning d-block");
            $('#notification-area').attr('role', 'alert');
            var spans = $('#notification-area span');
            for (var i = 0; i < spans.length; i++) {
              spans[i].remove(); 
            };
            $('#notification-area').append('<span class="aria-only">Notice: </span>');
            $('#notification-area').append('<span>The ORCID iD is invalid.</span>');
          } else if (response["status_code"][0] === '4') {
            // call was unsuccessful, problem with call made by client
            // inform user of outcome with flash message
            $('#notification-area').removeClass();
            $('#notification-area').addClass("notification-area alert alert-warning d-block");
            $('#notification-area').attr('role', 'alert');
            var spans = $('#notification-area span');
            for (var i = 0; i < spans.length; i++) {
              spans[i].remove(); 
            };
            $('#notification-area').append('<span class="aria-only">Notice: </span>');
            $('#notification-area').append('<span>There was a problem with the request made to the ORCID system, and so the record could not be retrieved.</span>');
          } else if (response["status_code"][0] === '5') {
            // call was unsuccessful, problem with server
            // inform user of outcome with flash message
            $('#notification-area').removeClass();
            $('#notification-area').addClass("notification-area alert alert-warning d-block");
            $('#notification-area').attr('role', 'alert');
            var spans = $('#notification-area span');
            for (var i = 0; i < spans.length; i++) {
              spans[i].remove(); 
            };
            $('#notification-area').append('<span class="aria-only">Notice: </span>');
            $('#notification-area').append('<span>There was a problem in ORCID system, and so the record could not be retrieved.</span>');
          } else {
            // call was unsuccessful, reason not clear
            // inform user of outcome with flash message
            $('#notification-area').removeClass();
            $('#notification-area').addClass("notification-area alert alert-warning d-block");
            $('#notification-area').attr('role', 'alert');
            var spans = $('#notification-area span');
            for (var i = 0; i < spans.length; i++) {
              spans[i].remove(); 
            };
            $('#notification-area').append('<span class="aria-only">Notice: </span>');
            $('#notification-area').append('<span>There was a problem in the system, and so the project details could not be retrieved.</span>');
          }
        }
      })
    }
  })
})