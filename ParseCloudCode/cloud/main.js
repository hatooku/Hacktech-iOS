
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

Parse.Cloud.afterSave("Announcements", function(request) {
  var titleText = request.object.get('Title');
  var pushed = request.object.get('pushed');

  // push === 1 means this row should be pushed
  if (pushed === 1) {
    var pushQuery = new Parse.Query(Parse.Installation);
    pushQuery.equalTo('deviceType', 'ios');

    Parse.Push.send({
      where: pushQuery, // Set our Installation query
      data: {
        alert: titleText,
        badge: 'Increment'
      }
    }, {
      success: function() {
        // Push was successful
      },
      error: function(error) {
        throw "Got an error " + error.code + " : " + error.message;
      }
    });
  }
});


// Manipulate "pushed" variable so each row is pushed only once even if it is edited.
Parse.Cloud.beforeSave("Announcements", function(request, response) {
  var titleText = request.object.get('Title');
  var descriptionText = request.object.get('Description');
  var pushed = request.object.get("pushed");

  var fieldsReady = (titleText && descriptionText != null);

  // "pushed" explanation:
  // null or 0: not pushed yet and fields not ready
  //         1: already pushed in the previous afterSave
  //         2: already pushed and edited again

  // If fields are ready and not pushed yet, set pushed to 1 so afterSave will send push
  if (fieldsReady && (pushed == null || pushed === 0)) {
      request.object.set("pushed", 1);
  }

  // If push is 1, already pushed in prev afterSave, so set push to 2
  else if (pushed === 1) {
    request.object.set("pushed", 2);
  }

  // Initialize to 0
  else if (pushed == null) {
    request.object.set("pushed", 0);
  }

  response.success();
});