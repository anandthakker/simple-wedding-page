
angular.module("athreadofsomething",[
  "firebase"
]).controller("RsvpCtrl", ($scope)->
  $scope.rsvp =
    attending: true
).directive("firebaseForm", ($firebase)->

  restrict: "A"
  replace: true
  transclude: true

  template: """
    <div class="firebase-form">
      <div class="message error" ng-show="error">
        {{errorMsg}}
      </div>

      <form ng-show="error || (!success && !saving)" ng-transclude>
      </form>

      <div class="message waiting" ng-show="saving">
        {{waitingMsg}}
      </div>
      <div class="message success" ng-show="success">
        {{successMsg}}
      </div>

    </div>

  """


  link: (scope, element, attrs)->

    db = new Firebase(attrs.firebaseUrl)

    scope.waitingMsg = attrs.waitingMsg ? "Saving..."
    scope.successMsg = attrs.successMsg ? "Thank you. Your response has been saved."
    scope.errorMsg = attrs.errorMsg ? "There was a problem saving your response."

    scope.saving = null
    scope.success = null
    scope.error = null


    scope.save = ()->
      console.log "Save"
      scope.data = scope.$eval(attrs.firebaseFormData)
      console.log scope.data
      scope.saving = true
      newRef = db.push()
      newRef.set(scope.data, (error) -> scope.$apply () ->
        console.log error
        scope.saving = false
        if error?
          scope.error = error
        else
          scope.success = true
      )
)



###
Yes, it would be more pure to Angular-ify this. 
###

$ ()->
  $('nav').waypoint('sticky')

  ###
  Code below borrowed from https://github.com/bmgdev/responsive-wedding/blob/master/js/main-1.6.js
  Copyright © Scal.io, LLC Bradley Greenwood
  ###
  navigation_listItems = $('nav li')
  navigation_links = $('nav li a')

  $('#container>section').waypoint
    handler: (event, direction) ->
      active_section = undefined
      active_section = $(this)
      active_section = active_section.prev()  if direction is "up"
      active_listItem = $("nav a[href=\"#" + active_section.attr("id") + "\"]").parent()
      navigation_listItems.removeClass "selected"
      active_listItem.addClass "selected"
      return

    offset: "15%"


  navigation_links.click (event) ->
    $.scrollTo $(this).attr("href"),
      duration: 1000
      offset:
        left: 0
        top: -0.08 * $(window).height()

    event.preventDefault()
    return

